#include "assert.h"
#include "audio.h"
#include "timer.h"
#include "irq_ctrl.h"
#include "irq.h"

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define AUDIO_CFG         0x0
    #define AUDIO_CFG_INT_THRESHOLD_SHIFT        0
    #define AUDIO_CFG_INT_THRESHOLD_MASK         0xffff

    #define AUDIO_CFG_BYTE_SWAP_SHIFT            16
    #define AUDIO_CFG_BYTE_SWAP_MASK             0x1

    #define AUDIO_CFG_CH_SWAP_SHIFT              17
    #define AUDIO_CFG_CH_SWAP_MASK               0x1

    #define AUDIO_CFG_TARGET_SHIFT               18
    #define AUDIO_CFG_TARGET_MASK                0x3
    #define AUDIO_CFG_TARGET_I2S                 0
    #define AUDIO_CFG_TARGET_SPDIF               1
    #define AUDIO_CFG_TARGET_ANALOG              2

    #define AUDIO_CFG_VOL_CTRL_SHIFT             24
    #define AUDIO_CFG_VOL_CTRL_MASK              0x7

    #define AUDIO_CFG_BUFFER_RST_SHIFT           31
    #define AUDIO_CFG_BUFFER_RST_MASK            0x1

#define AUDIO_STATUS      0x4
    #define AUDIO_STATUS_LEVEL_SHIFT             16
    #define AUDIO_STATUS_LEVEL_MASK              0xffff

    #define AUDIO_STATUS_FULL_SHIFT              1
    #define AUDIO_STATUS_FULL_MASK               0x1

    #define AUDIO_STATUS_EMPTY_SHIFT             0
    #define AUDIO_STATUS_EMPTY_MASK              0x1

#define AUDIO_CLK_DIV     0x8
    #define AUDIO_CLK_DIV_WHOLE_CYCLES_SHIFT     0
    #define AUDIO_CLK_DIV_WHOLE_CYCLES_MASK      0xffff

#define AUDIO_CLK_FRAC    0xc
    #define AUDIO_CLK_FRAC_NUMERATOR_SHIFT       0
    #define AUDIO_CLK_FRAC_NUMERATOR_MASK        0xffff

    #define AUDIO_CLK_FRAC_DENOMINATOR_SHIFT     16
    #define AUDIO_CLK_FRAC_DENOMINATOR_MASK      0xffff

#define AUDIO_FIFO_WRITE  0x20
    #define AUDIO_FIFO_WRITE_CH_B_SHIFT          0
    #define AUDIO_FIFO_WRITE_CH_B_MASK           0xffff

    #define AUDIO_FIFO_WRITE_CH_A_SHIFT          16
    #define AUDIO_FIFO_WRITE_CH_A_MASK           0xffff

#define AUDIO_FIFO_SIZE   2048

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
static volatile uint32_t *m_audio;
static int                m_irq;

//-----------------------------------------------------------------
// Locals:
//-----------------------------------------------------------------
static struct link_list     _buffer_list;

//-----------------------------------------------------------------
// audio_load_samples
//-----------------------------------------------------------------
static void audio_load_samples(uint32_t *p, int length)
{
    while (length)
    {
        uint32_t space = AUDIO_FIFO_SIZE - ((m_audio[AUDIO_STATUS/4] >> AUDIO_STATUS_LEVEL_SHIFT) & AUDIO_STATUS_LEVEL_MASK);

        if (space > length)
            space = length;

        length -= space;

        while (space--)
            m_audio[AUDIO_FIFO_WRITE/4] = *p++;
    }
}
//-----------------------------------------------------------------
// audio_irq
//-----------------------------------------------------------------
static void* audio_irq(void *ctx, int irq)
{
    struct audiobuf* buf;
    struct link_node *node;
    uint32_t sts;
    uint32_t fifo_space = AUDIO_FIFO_SIZE - ((m_audio[AUDIO_STATUS/4] >> AUDIO_STATUS_LEVEL_SHIFT) & AUDIO_STATUS_LEVEL_MASK);
    int size;

    // Get the first buffer     
    node = list_first(&_buffer_list);
    if (!node)
    {
        irqctrl_enable_irq(m_irq, 0);
        return ctx;
    }

    buf = list_entry(node, struct audiobuf, list_entry);

    // Min of FIFO size or buffer remainder
    if (buf->size > fifo_space)
        size = fifo_space;
    else
        size = buf->size;

    // Load audio samples into buffer
    audio_load_samples(buf->ptr, size);
    buf->ptr  += (size * 2);
    buf->size -= size;

    if (buf->size == 0)
    {
        // Remove from the play list
        list_remove(&_buffer_list, &buf->list_entry);

        // Release audio buffer
        audiobuf_free(buf);
        buf = 0;
    }

    // Enable audio output interrupt
    irqctrl_enable_irq(m_irq, 1);

    return ctx;
}
//-----------------------------------------------------------------
// audio_init
//-----------------------------------------------------------------
void audio_init(uint32_t base_addr, int irq_num, uint32_t clock_rate, tAudioTarget target)
{
    audiobuf_init();

    m_audio = (volatile uint32_t *) base_addr;
    m_irq   = irq_num;

    m_audio[AUDIO_CFG/4] = /*(3 << AUDIO_CFG_VOL_CTRL_SHIFT) | */
                            (target << AUDIO_CFG_TARGET_SHIFT) | 
                            ((AUDIO_FIFO_SIZE/4) << AUDIO_CFG_INT_THRESHOLD_SHIFT);

    if (target == AUDIO_TARGET_SPDIF)
    {
        switch (clock_rate)
        {
            case 48000000:
                // 48000000÷5644800 = 8.5034
                m_audio[AUDIO_CLK_DIV/4]  =  8;
                m_audio[AUDIO_CLK_FRAC/4] = (10000 << AUDIO_CLK_FRAC_DENOMINATOR_SHIFT) | 5034;            
                break;
            default:
                assert(!"unsupported");
                break;
        }
    }
    else if (target == AUDIO_TARGET_ANALOG)
    {
        switch (clock_rate)
        {
            case 50000000:
                // 50000000÷44100 = 1133.786848073
                m_audio[AUDIO_CLK_DIV/4]  =  1133;
                m_audio[AUDIO_CLK_FRAC/4] = (60000 << AUDIO_CLK_FRAC_DENOMINATOR_SHIFT) | 47210;
                break;
            default:
                assert(!"unsupported");
                break;
        }
    }
    else
    {
        assert(!"unsupported");
    }

    // Initialise play buffer list
    list_init(&_buffer_list);

    // Register IRQ handler
    irqctrl_set_handler(m_irq, audio_irq);
    irqctrl_enable_irq(m_irq, 0);
}
//-----------------------------------------------------------------
// audio_queue_buffer
//-----------------------------------------------------------------
void audio_queue_buffer(struct audiobuf *buf)
{
    // Add buffer to play list
    int cr = irq_critical_start();  
    list_insert_last(&_buffer_list, &buf->list_entry);
    irq_critical_end(cr);   

    // Enable audio output interrupt
    irqctrl_enable_irq(m_irq, 1); 
}
//-----------------------------------------------------------------
// audio_swap_channels
//-----------------------------------------------------------------
void audio_swap_channels(int enable)
{
    uint32_t cfg = m_audio[AUDIO_CFG/4];

    cfg &= ~(1 << AUDIO_CFG_CH_SWAP_SHIFT);
    cfg |=  (enable << AUDIO_CFG_CH_SWAP_SHIFT);

    m_audio[AUDIO_CFG/4] = cfg;
}
//-----------------------------------------------------------------
// audio_swap_endian
//-----------------------------------------------------------------
void audio_swap_endian(int enable)
{
    uint32_t cfg = m_audio[AUDIO_CFG/4];

    cfg &= ~(1 << AUDIO_CFG_BYTE_SWAP_SHIFT);
    cfg |=  (enable << AUDIO_CFG_BYTE_SWAP_SHIFT);

    m_audio[AUDIO_CFG/4] = cfg;
}
//-----------------------------------------------------------------
// audio_set_volume
//-----------------------------------------------------------------
void audio_set_volume(int percent)
{
    uint32_t cfg = m_audio[AUDIO_CFG/4];
    uint32_t vol = percent;

    if (percent > 100)
        vol = 100;
    else if (percent < 0)
        vol = 0;

    vol *= 8;
    vol /= 100;
    vol = 8 - vol;

    cfg &= ~(AUDIO_CFG_VOL_CTRL_MASK << AUDIO_CFG_VOL_CTRL_SHIFT);
    cfg |=  (vol << AUDIO_CFG_VOL_CTRL_SHIFT);

    m_audio[AUDIO_CFG/4] = cfg;
}