OUT := rmtfs

CFLAGS += -Wall -g -O2
LDFLAGS += -lqrtr -ludev -lpthread
prefix = /usr
bindir := $(prefix)/sbin
servicedir := $(prefix)/lib/systemd/system

SRCS := qmi_rmtfs.c rmtfs.c rproc.c sharedmem.c storage.c util.c
OBJS := $(SRCS:.c=.o)

$(OUT): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

# %.c: %.qmi
#	qmic -k < $<

rmtfs.service: rmtfs.service.in
	@sed 's+RMTFS_PATH+$(bindir)+g' $< > $@

install: $(OUT)
	@install -D -m 755 $(OUT) $(DESTDIR)$(prefix)/sbin/$(OUT)
	@install -D -m 755 rmtfs.initd $(DESTDIR)etc/init.d/$(OUT)
	@install -D -m 644 udev.rules $(DESTDIR)lib/udev/rules.d/65-$(OUT).rules

clean:
	rm -f $(OUT) $(OBJS) rmtfs.service

