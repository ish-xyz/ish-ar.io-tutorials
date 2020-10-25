#include<linux/module.h>
#include<linux/version.h>
#include<linux/kernel.h>
#include<linux/init.h>
#include<linux/kprobes.h>

static unsigned int counter = 0;

static struct kprobe kp;


int kpb_pre(struct kprobe *p, struct pt_regs *regs){
    printk("ish-ar.io pre_handler: counter=%u\n",counter++);
    return 0;
}

void kpb_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags){
    printk("ish-ar.io post_handler: counter=%u\n",counter++);
}

int minit(void)
{
    printk("Module inserted\n ");
    kp.pre_handler = kpb_pre;
    kp.post_handler = kpb_post;
    kp.addr = (kprobe_opcode_t *)0xFUNCTION_MEMORY_ADDRESS;
    register_kprobe(&kp);
    return 0;
}

void mexit(void)
{
    unregister_kprobe(&kp);
    printk("Module removed\n ");
}

module_init(minit);
module_exit(mexit);
MODULE_AUTHOR("Isham J. Araia");
MODULE_DESCRIPTION("https://ish-ar.io/");
MODULE_LICENSE("GPL");
