/* xconfig.h.  Generated automatically by configure.  */
/* @(#)xconfig.h.in	1.271 17/08/05 Copyright 1998-2017 J. Schilling */
/*
 *	Dynamic autoconf C-include code.
 *	Do not edit, this file has been created automatically.
 *
 *	Copyright (c) 1998-2017 J. Schilling
 *
 *	The layout for this file is controlled by "configure".
 *	Switch off cstyle(1) checks for now.
 */
#ifndef	__XCONFIG_H
#define	__XCONFIG_H
/* BEGIN CSTYLED */

/*
 * Header Files
 */
/* #undef PROTOTYPES */	/* if Compiler supports ANSI C prototypes */
#define HAVE_INLINE 1	/* if Compiler supports "inline" keyword */
#define HAVE_AR_H 1	/* to use ar.h */
#define HAVE_ASSERT_H 1	/* to use assert.h */
#define HAVE_STDIO_H 1	/* to use stdio.h */
#define HAVE_STDARG_H 1	/* to use stdarg.h, else use varargs.h NOTE: SaberC on a Sun has prototypes but no stdarg.h */
/* #undef HAVE_VARARGS_H */	/* to use use varargs.h NOTE: The free HP-UX C-compiler has stdarg.h but no PROTOTYPES */
#define HAVE_STDLIB_H 1	/* to use general utility defines (malloc(), size_t ...) and general C library prototypes */
#define HAVE_STDDEF_H 1	/* to use offsetof(), ptrdiff_t, wchar_t, size_t */
#define HAVE_STRING_H 1	/* to get NULL and ANSI C string function prototypes */
#define HAVE_STRINGS_H 1	/* to get BSD string function prototypes */
/* #undef STDC_HEADERS */	/* if ANSI compliant stdlib.h, stdarg.h, string.h, float.h are present */
#define HAVE_UNISTD_H 1	/* to get POSIX syscall prototypes XXX sys/file.h fcntl.h (unixstd/fctl)XXX*/
#define HAVE_GETOPT_H 1	/* to get getopt() prototype from getopt.h instead of unistd.h */
#define HAVE_LIMITS_H 1	/* to get POSIX numeric limits constants */
/* #undef HAVE_A_OUT_H */	/* if a.out.h is present (may be a system using a.out format) */
/* #undef HAVE_AOUTHDR_H */	/* if aouthdr.h is present. This is a COFF system */
/* #undef HAVE_ELF_H */	/* if elf.h is present. This is an ELF system */
#define HAVE_FCNTL_H 1	/* to access, O_XXX constants for open(), otherwise use sys/file.h */
/* #undef HAVE_IO_H */	/* to access setmode()... from WIN-DOS, OS/2 and similar */
/* #undef HAVE_CONIO_H */	/* to access getch()... from WIN-DOS, OS/2 and similar */
#define HAVE_SYS_FILE_H 1	/* to use O_XXX constants for open() and flock() defs */
#define HAVE_INTTYPES_H 1	/* to use UNIX-98 inttypes.h */
#define HAVE_STDINT_H 1	/* to use SUSv3 stdint.h */
#define HAVE_DIRENT_H 1	/* to use POSIX dirent.h */
/* #undef HAVE_SYS_DIR_H */	/* to use BSD sys/dir.h */
/* #undef HAVE_NDIR_H */	/* to use ndir.h */
/* #undef HAVE_SYS_NDIR_H */	/* to use sys/ndir.h */
#define HAVE_ALLOCA_H 1	/* if alloca.h exists */
/* #undef HAVE_MALLOC_H */	/* if malloc.h exists */
/* #undef HAVE_POSIX_MALLOC_H */ /* The Haiku include file for malloc()/valloc()/... */
#define HAVE_SGTTY_H 1	/* if sgtty.h exists */
#define HAVE_TERMIOS_H 1	/* to use POSIX termios.h */
/* #undef HAVE_TERMIO_H */	/* to use SVR4 termio.h */
#define HAVE_PWD_H 1	/* if pwd.h exists */
#define HAVE_GRP_H 1	/* if grp.h exists */
#define HAVE_SIGNAL_H 1	/* if signal.h exists */
/* #undef HAVE_SIGINFO_H */	/* if siginfo.h exists */
/* #undef HAVE_SYS_SIGINFO_H */ /* if sys/siginfo.h exists */
/* #undef HAVE_UCONTEXT_H */	/* if ucontext.h exists */
#define HAVE_SYS_ACL_H 1	/* to use <sys/acl.h> for ACL definitions */
/* #undef HAVE_ACLUTILS_H */	/* to use <aclutils.h> for NFSv4 ACL extensions */
/* #undef HAVE_ACLLIB_H */	/* if HP-UX <acllib.h> is present */
/* #undef HAVE_ACL_LIBACL_H */ /* if Linux <acl/libacl.h> is present */
/* #undef HAVE_SHADOW_H */	/* if shadow.h exists */
#define HAVE_SYSLOG_H 1	/* if syslog.h exists */
#define HAVE_SYS_TIME_H 1	/* may include sys/time.h for struct timeval */
#define TIME_WITH_SYS_TIME 1	/* may include both time.h and sys/time.h */
#define HAVE_TIMES 1	/* to use times() and sys/times.h */
#define HAVE_SYS_TIMES_H 1	/* may include sys/times.h for struct tms */
#define HAVE_UTIME 1		/* to use AT&T utime() and utimbuf */
#define HAVE_UTIMES 1		/* to use BSD utimes() and sys/time.h */
#define HAVE_FUTIMES 1		/* to use BSD futimes() and sys/time.h */
#define HAVE_LUTIMES 1		/* to use BSD lutimes() and sys/time.h */
/* #undef HAVE_UTIMENS */		/* to use BSD utimens() and sys/time.h */
#define HAVE_FUTIMENS 1		/* to use BSD futimens() and sys/time.h */
/* #undef HAVE_LUTIMENS */		/* to use BSD lutimens() and sys/time.h */
#define HAVE_UTIME_H 1		/* to use utime.h for the utimbuf structure declaration, else declare struct utimbuf yourself */
/* #undef HAVE_SYS_UTIME_H */		/* to use sys/utime.h if utime.h does not exist */
#define HAVE_SYS_IOCTL_H 1		/* if sys/ioctl.h is present */
#define HAVE_SYS_FILIO_H 1		/* if sys/filio.h is present */
#define HAVE_SYS_PARAM_H 1		/* if sys/param.h is present */
#define HAVE_MACH_MACHINE_H 1	/* if mach/machine.h is present */
/* #undef HAVE_MNTENT_H */		/* if mntent.h is present */
/* #undef HAVE_SYS_MNTENT_H */	/* if sys/mntent.h is present */
/* #undef HAVE_SYS_MNTTAB_H */	/* if sys/mnttab.h is present */
#define HAVE_SYS_MOUNT_H 1		/* if sys/mount.h is present */
/* #undef HAVE_WAIT_H */		/* to use wait.h for prototypes and union wait */
#define HAVE_SYS_WAIT_H 1		/* else use sys/wait.h */
#define HAVE_ULIMIT_H 1		/* to use ulimit() as fallback for getrlimit()  */
/* #undef HAVE_PROCESS_H */		/* to use process.h for spawn*() and cwait() */
#define HAVE_SYS_RESOURCE_H 1	/* to use sys/resource.h for rlimit() and wait3() */
/* #undef HAVE_PROCFS_H */		/* to use procfs.h instead of sys/procfs.h (Solaris forces profcs-2) */
/* #undef HAVE_SYS_PROCFS_H */	/* to use sys/procfs.h for wait3() emulation */
#define HAVE_LIBPROC_H 1		/* to use libproc.h (Mac OS X) */
/* #undef HAVE_SYS_SYSTEMINFO_H */	/* to use SVr4 sysinfo() */
#define HAVE_SYS_SYSCTL_H 1	/* to use BSD sysctl() */
#define HAVE_SYS_UTSNAME_H 1	/* to use uname() */
/* #undef HAVE_SYS_PRIOCNTL_H */	/* to use SVr4 priocntl() instead of nice()/setpriority() */
/* #undef HAVE_SYS_RTPRIOCNTL_H */	/* if the system supports SVr4 real time classes */
/* #undef HAVE_SYS_PROCSET_H */	/* if the system supports SVr4 process sets */
/* #undef HAVE_SYS_LOADAVG_H */	/* to use getloadavg() */
#define HAVE_SYS_SYSCALL_H 1	/* to use syscall() */
/* #undef HAVE_SYS_MTIO_H */		/* to use mtio definitions from sys/mtio.h */
/* #undef HAVE_SYS_TAPE_H */		/* to use mtio definitions from AIX sys/tape.h */
#define HAVE_SYS_MMAN_H 1		/* to use definitions for mmap()/madvise()... from sys/mman.h */
#define HAVE_SYS_SHM_H 1		/* to use definitions for shmget() ... from sys/shm.h */
#define HAVE_SYS_SEM_H 1		/* to use definitions for semget() ... from sys/sem.h */
#define HAVE_SYS_IPC_H 1		/* to use definitions for ftok() ... from sys/ipc.h */
#define HAVE_SEMAPHORE_H 1		/* to use definitions for sema_init() ... from semaphore.h */
/* #undef MAJOR_IN_MKDEV */		/* if we should include sys/mkdev.h to get major()/minor()/makedev() */
/* #undef MAJOR_IN_SYSMACROS */	/* if we should include sys/sysmacros.h to get major()/minor()/makedev() */
/* #undef HAVE_SYS_DKIO_H */		/* if we may include sys/dkio.h for disk ioctls */
/* #undef HAVE_SYS_DKLABEL_H */	/* if we may include sys/dklabel.h for disk label */
/* #undef HAVE_SUN_DKIO_H */		/* if we may include sun/dkio.h for disk ioctls */
/* #undef HAVE_SUN_DKLABEL_H */	/* if we may include sun/dklabel.h for disk label */
#define HAVE_SYS_TYPES_H 1		/* if we may include sys/types.h (the standard) */
/* #undef HAVE_SYS_STYPES_H */	/* if we may include sys/stypes.h (JOS) */
#define HAVE_SYS_FILEDESC_H 1	/* if we may include sys/filedesc.h (JOS) */
#define HAVE_SYS_STAT_H 1		/* if we may include sys/stat.h (the standard) */
#define HAVE_SYS_ACCT_H 1		/* if we may include sys/acct.h */
/* #undef HAVE_TYPES_H */		/* if we may include types.h (rare cases e.g. ATARI TOS) */
/* #undef HAVE_STAT_H */		/* if we may include stat.h (rare cases e.g. ATARI TOS) */
#define HAVE_POLL_H 1		/* if we may include poll.h to use poll() */
#define HAVE_SYS_POLL_H 1		/* if we may include sys/poll.h to use poll() */
#define HAVE_SYS_SELECT_H 1	/* if we may have sys/select.h nonstandard use for select() on some systems*/
/* #undef NEED_SYS_SELECT_H */	/* if we need sys/select.h to use select() (this is nonstandard) */
#define HAVE_NETDB_H 1		/* if we have netdb.h for get*by*() and rcmd() */
/* #undef HAVE_ARPA_AIXRCMDS_H */	/* if we have arpa/aixrcmds.h for get*by*() and rcmd() */
#define HAVE_SYS_SOCKET_H 1	/* if we have sys/socket.h for socket() */
/* #undef NEED_SYS_SOCKET_H */	/* if we need sys/socket.h to use select() (this is nonstandard) */
#define HAVE_NETINET_IN_H 1	/* if we have netinet/in.h */
/* #undef HAVE_STROPTS_H */		/* if we have stropts.h */
/* #undef HAVE_LINUX_PG_H */		/* if we may include linux/pg.h for PP ATAPI sypport */
/* #undef HAVE_CAMLIB_H */		/* if we may include camlib.h for CAM SCSI transport definitions */
/* #undef HAVE_IEEEFP_H */		/* if we may include ieeefp.h for finite()/isnand() */
/* #undef HAVE_FP_H */		/* if we may include fp.h for FINITE()/IS_INF()/IS_NAN() */
/* #undef HAVE_VALUES_H */		/* if we may include values.h for MAXFLOAT */
#define HAVE_FLOAT_H 1		/* if we may include float.h for FLT_MAX */
#define HAVE_MATH_H 1		/* if we may include math.h for e.g. isinf()/isnan() */
/* #undef HAVE__FILBUF */		/* if we have _filbuf() for USG derived STDIO */
/* #undef HAVE___FILBUF */		/* if we have __filbuf() for USG derived STDIO */
/* #undef HAVE_USG_STDIO */		/* if we have USG derived STDIO */
#define HAVE_ERRNO_DEF 1		/* if we have errno definition in <errno.h> */
/* #undef HAVE_ENVIRON_DEF */		/* if we have environ definition in <unistd.h> */
/* #undef HAVE_SYS_SIGLIST_DEF */	/* if we have sys_siglist definition in <signal.h> */
/* #undef HAVE_SYS_FORK_H */		/* if we should include sys/fork.h for forkx() definitions */
/* #undef HAVE_VFORK_H */		/* if we should include vfork.h for vfork() definitions */
#define HAVE_ARPA_INET_H 1		/* if we have arpa/inet.h (missing on BeOS) */
				/* BeOS has inet_ntoa() in <netdb.h> */
#define HAVE_RPC_RPC_H 1		/* if we may include rpc/rpc.h */
/* #undef HAVE_BSD_DEV_SCSIREG_H */	/* if we have a NeXT Step compatible sg driver */
/* #undef HAVE_SCSI_SCSI_H */		/* if we may include scsi/scsi.h */
/* #undef HAVE_SCSI_SG_H */		/* if we may include scsi/sg.h */
/* #undef HAVE_LINUX_SCSI_H */	/* if we may include linux/scsi.h */
/* #undef HAVE_LINUX_SG_H */		/* if we may include linux/sg.h */
/* #undef HAVE_LINUX_TYPES_H */	/* if we may include linux/types.h */
/* #undef HAVE_LINUX_GFP_H */		/* if we may include linux/gfp.h */
/* #undef HAVE_ASM_TYPES_H */		/* if we may include asm/types.h */
/* #undef HAVE_SYS_CAPABILITY_H */	/* if we may include sys/capability.h */
/* #undef HAVE_SYS_BSDTTY_H */	/* if we have sys/bsdtty.h on HP-UX for TIOCGPGRP */
/* #undef HAVE_OS_H */		/* if we have the BeOS kernel definitions in OS.h */
/* #undef HAVE_OS2_H */		/* if we have the OS/2 definitions in os2.h */
/* #undef HAVE_OS2ME_H */		/* if we have the OS/2 definitions in os2me.h */
/* #undef HAVE_WINDOWS_H */		/* if we have the MS-Win definitions in windows.h */
/* #undef HAVE_EXT2FS_EXT2_FS_H */	/* if we have the Linux moving target ext2fs/ext2_fs.h */
/* #undef HAVE_ATTR_XATTR_H */	/* if we have the Linux Extended File Attr definitions in attr/xattr.h */
#define HAVE_CRT_EXTERNS_H 1	/* if we have the Mac OS X env definitions in crt_externs.h */
#define HAVE_FNMATCH_H 1		/* if we may include fnmatch.h */
/* #undef HAVE_DIRECT_H */		/* if we may include direct.h  (MSVC for getcwd()/chdir()/mkdir()/rmdir()) */
#define HAVE_SYSEXITS_H 1		/* if we may include sysexits.h */

/* #undef HAVE_LIBINTL_H */		/* if we may include libintl.h */
#define HAVE_LOCALE_H 1		/* if we may include locale.h */
#define HAVE_LANGINFO_H 1		/* if we may include langinfo.h */
#define HAVE_NL_TYPES_H 1		/* if we may include nl_types.h */
#define HAVE_CTYPE_H 1		/* if we may include ctype.h */
#define HAVE_WCTYPE_H 1		/* if we may include wctype.h */
#define HAVE_WCHAR_H 1		/* if we may include wchar.h */
#define HAVE_ICONV_H 1		/* if we may include iconv.h */

/* #undef HAVE_PRIV_H */		/* if we may include priv.h */
/* #undef HAVE_SYS_PRIV_H */		/* if we may include sys/priv.h */
/* #undef HAVE_EXEC_ATTR_H */		/* if we may include exec_attr.h */
/* #undef HAVE_SECDB_H */		/* if we may include secdb.h */
#define HAVE_PTHREAD_H 1		/* if we may include pthread.h */
/* #undef HAVE_THREAD_H */		/* if we may include thread.h */

#define HAVE_LIBGEN_H 1		/* if we may include libgen.h */
#define HAVE_REGEX_H 1		/* if we may include regex.h */
/* #undef HAVE_REGEXP_H */		/* if we may include regexp.h */
/* #undef HAVE_REGEXPR_H */		/* if we may include regexpr.h */

#define HAVE_DLFCN_H 1		/* if we may include dlfcn.h */
/* #undef HAVE_LINK_H */		/* if we may include link.h */
/* #undef HAVE_DL_H */		/* if we may include dl.h */
/* #undef HAVE_LIBELF_H */		/* if we may include libelf.h */

#define HAVE_RANLIB_H 1		/* if we may include ranlib.h */

#define HAVE_EXPAT_H 1		/* if we may include expat.h */

/*
 * Convert to SCHILY name
 */
#ifdef	STDC_HEADERS
#	ifndef	HAVE_STDC_HEADERS
#		define	HAVE_STDC_HEADERS
#	endif
#endif

#ifdef	HAVE_ELF_H
#define	HAVE_ELF			/* This system uses ELF */
#else
#	ifdef	HAVE_AOUTHDR_H
#	define	HAVE_COFF		/* This system uses COFF */
#	else
#		ifdef HAVE_A_OUT_H
#		define HAVE_AOUT	/* This system uses AOUT */
#		endif
#	endif
#endif

/*
 * Function declarations
 */
/* #undef HAVE_DECL_STAT */		/* Whether <sys/stat.h> defines extern stat(); */
/* #undef HAVE_DECL_LSTAT */		/* Whether <sys/stat.h> defines extern lstat(); */

/*
 * Library Functions
 */
#define HAVE_ACCESS 1		/* access() is present in libc */
/* #undef HAVE_EACCESS */		/* eaccess() is present in libc */
/* #undef HAVE_EUIDACCESS */		/* euidaccess() is present in libc */
/* #undef HAVE_ACCESS_E_OK */		/* access() implements E_OK (010) for effective UIDs */
#define HAVE_CRYPT_IN_LIBC 1	/* whether crypt() is in libc (needs no -lcrypt) */
#define HAVE_CRYPT 1		/* crypt() is present in libc or libcrypt */
#define HAVE_STRERROR 1		/* strerror() is present in libc */
#define HAVE_MEMCHR 1		/* memchr() is present in libc */
#define HAVE_MEMCMP 1		/* memcmp() is present in libc */
#define HAVE_MEMCPY 1		/* memcpy() is present in libc */
#define HAVE_MEMCCPY 1		/* memccpy() is present in libc */
#define HAVE_MEMMOVE 1		/* memmove() is present in libc */
#define HAVE_MEMSET 1		/* memset() is present in libc */
#define HAVE_MADVISE 1		/* madvise() is present in libc */
/* #undef HAVE_MLOCK */		/* mlock() is present in libc */
/* #undef HAVE_MLOCKALL */		/* working mlockall() is present in libc */
/* #undef HAVE_MMAP */		/* working mmap() is present in libc */
/* #undef _MMAP_WITH_SIZEP */		/* mmap() needs address of size parameter */
#define HAVE_FLOCK 1		/* *BSD flock() is present in libc */
#define HAVE_LOCKF 1		/* lockf() is present in libc (XOPEN) */
#define HAVE_FCNTL_LOCKF 1		/* file locking via fcntl() is present in libc */
#define HAVE_FCHDIR 1		/* fchdir() is present in libc */
#define HAVE_FDOPENDIR 1		/* fdopendir() is present in libc */
#define HAVE_GETDELIM 1		/* getdelim() is present in libc */
#define HAVE_OPENAT 1		/* openat() is present in libc */
/* #undef HAVE_ATTROPEN */		/* attropen() is present in libc */
#define HAVE_FSTATAT 1		/* fstatat() is present in libc */
#define HAVE_FCHOWNAT 1		/* fchownat() is present in libc */
/* #undef HAVE_FUTIMESAT */		/* futimesat() is present in libc */
#define HAVE_RENAMEAT 1		/* renameat() is present in libc */
#define HAVE_UNLINKAT 1		/* unlinkat() is present in libc */
/* #undef HAVE___ACCESSAT */		/* __accessat() is present in libc */
/* #undef HAVE_ACCESSAT */		/* accessat() is present in libc */
#define HAVE_REALPATH 1		/* realpath() is present in libc */
/* #undef HAVE_RESOLVEPATH */		/* resolvepath() is present in libc */
/*
 * See e.g. http://www.die.net/doc/linux/man/man2/mkdirat.2.html
 */
#define HAVE_MKDIRAT 1		/* mkdirat() is present in libc */
#define HAVE_FACCESSAT 1		/* faccessat() is present in libc */
#define HAVE_FCHMODAT 1		/* fchmodat() is present in libc */
#define HAVE_LINKAT 1		/* inkat() is present in libc */
#define HAVE_MKFIFOAT 1		/* mkfifoat() is present in libc */
#define HAVE_MKNODAT 1		/* mknodat() is present in libc */
#define HAVE_READLINKAT 1		/* readlinkat() is present in libc */
#define HAVE_SYMLINKAT 1		/* symlinkat() is present in libc */
#define HAVE_UTIMENSAT 1		/* utimensat() is present in libc */
#define HAVE_IOCTL 1		/* ioctl() is present in libc */
#define HAVE_FCNTL 1		/* fcntl() is present in libc */
#define HAVE_PIPE 1		/* pipe() is present in libc */
/* #undef HAVE__PIPE */		/* _pipe() is present in libc */
#define HAVE_POPEN 1		/* popen() is present in libc */
#define HAVE_PCLOSE 1		/* pclose() is present in libc */
/* #undef HAVE__POPEN */		/* _popen() is present in libc */
/* #undef HAVE__PCLOSE */		/* _pclose() is present in libc */
/* #undef HAVE_CLOSEFROM */		/* closefrom() is present in libc */
#define HAVE_STATVFS 1		/* statvfs() is present in libc */
#define HAVE_QUOTACTL 1		/* quotactl() is present in libc */
/* #undef HAVE_QUOTAIOCTL */		/* use ioctl(f, Q_QUOTACTL, &q) instead of quotactl() */
#define HAVE_GETPID 1		/* getpid() is present in libc */
#define HAVE_GETPPID 1		/* getppid() is present in libc */
#define HAVE_SETREUID 1		/* setreuid() is present in libc */
/* #undef HAVE_SETRESUID */		/* setresuid() is present in libc */
#define HAVE_SETEUID 1		/* seteuid() is present in libc */
#define HAVE_SETUID 1		/* setuid() is present in libc */
#define HAVE_SETREGID 1		/* setregid() is present in libc */
/* #undef HAVE_SETRESGID */		/* setresgid() is present in libc */
#define HAVE_SETEGID 1		/* setegid() is present in libc */
#define HAVE_SETGID 1		/* setgid() is present in libc */
#define HAVE_GETUID 1		/* getuid() is present in libc */
#define HAVE_GETEUID 1		/* geteuid() is present in libc */
#define HAVE_GETGID 1		/* getgid() is present in libc */
#define HAVE_GETEGID 1		/* getegid() is present in libc */
#define HAVE_GETPGID 1		/* getpgid() is present in libc (POSIX) */
#define HAVE_SETPGID 1		/* setpgid() is present in libc (POSIX) */
#define HAVE_GETPGRP 1		/* getpgrp() is present in libc (ANY) */
#define HAVE_GETSID 1		/* getsid() is present in libc (POSIX) */
#define HAVE_SETSID 1		/* setsid() is present in libc (POSIX) */
#define HAVE_SETPGRP 1		/* setpgrp() is present in libc (ANY) */
/* #undef HAVE_BSD_GETPGRP */		/* getpgrp() in libc is BSD-4.2 compliant */
/* #undef HAVE_BSD_SETPGRP */		/* setpgrp() in libc is BSD-4.2 compliant */
#define HAVE_GETPWNAM 1		/* getpwnam() in libc */
#define HAVE_GETPWENT 1		/* getpwent() in libc */
#define HAVE_GETPWUID 1		/* getpwuid() in libc */
#define HAVE_SETPWENT 1		/* setpwent() in libc */
#define HAVE_ENDPWENT 1		/* endpwent() in libc */
#define HAVE_GETGRNAM 1		/* getgrnam() in libc */
#define HAVE_GETGRENT 1		/* getgrent() in libc */
#define HAVE_GETGRGID 1		/* getgrgid() in libc */
#define HAVE_SETGRENT 1		/* setgrent() in libc */
#define HAVE_ENDGRENT 1		/* endgrent() in libc */
/* #undef HAVE_GETSPNAM */		/* getspnam() in libc (SVR4 compliant) */
/* #undef HAVE_GETSPWNAM */		/* getspwnam() in libsec.a (HP-UX) */
#define HAVE_GETLOGIN 1		/* getlogin() in libc */
#define HAVE_SYNC 1		/* sync() is present in libc */
#define HAVE_FSYNC 1		/* fsync() is present in libc */
/* #undef HAVE_TCGETATTR */		/* tcgetattr() is present in libc */
/* #undef HAVE_TCSETATTR */		/* tcsetattr() is present in libc */
#define HAVE_TCGETPGRP 1		/* tcgetpgrp() is present in libc */
#define HAVE_TCSETPGRP 1		/* tcsetpgrp() is present in libc */
#define HAVE_TCGETSID 1		/* tcgetsid() is present in libc */
#define HAVE_WAIT 1		/* wait() is present in libc */
/* #undef HAVE_WAIT3 */		/* working wait3() is present in libc */
#define HAVE_WAIT4 1		/* wait4() is present in libc */
/* #undef HAVE_WAIT6 */		/* wait6() is present in libc */
#define HAVE_WAITID 1		/* waitid() is present in libc */
#define HAVE_WAITPID 1		/* waitpid() is present in libc */
/* #undef HAVE_WNOWAIT_WAITPID */	/* waitpid() supports NOWAIT */
/* #undef HAVE_CWAIT */		/* cwait() is present in libc */
#define HAVE_GETHOSTID 1		/* gethostid() is present in libc */
#define HAVE_GETHOSTNAME 1		/* gethostname() is present in libc */
#define HAVE_GETDOMAINNAME 1	/* getdomainname() is present in libc */
/* #undef HAVE_GETPAGESIZE */		/* getpagesize() is present in libc */
#define HAVE_GETDTABLESIZE 1	/* getdtablesize() is present in libc */
#define HAVE_GETRUSAGE 1		/* getrusage() is present in libc */
#define HAVE_GETRLIMIT 1		/* getrlimit() is present in libc */
#define HAVE_SETRLIMIT 1		/* setrlimit() is present in libc */
#define HAVE_ULIMIT 1		/* ulimit() is present in libc */
#define HAVE_GETTIMEOFDAY 1	/* gettimeofday() is present in libc */
#define HAVE_SETTIMEOFDAY 1	/* settimeofday() is present in libc */
/* #undef HAVE_VAR_TIMEZONE */	/* extern long timezone is present in libc */
#define HAVE_VAR_TIMEZONE_DEF 1	/* extern long timezone is present in time.h */
#define HAVE_TIME 1		/* time() is present in libc */
#define HAVE_GMTIME 1		/* gmtime() is present in libc */
#define HAVE_LOCALTIME 1		/* localtime() is present in libc */
#define HAVE_MKTIME 1		/* mktime() is present in libc */
#define HAVE_TIMEGM 1		/* timegm() is present in libc */
#define HAVE_TIMELOCAL 1		/* timelocal() is present in libc */
#define HAVE_FTIME 1		/* ftime() is present in libc */
/* #undef HAVE_STIME */		/* stime() is present in libc */
#define HAVE_TZSET 1		/* tzset() is present in libc */
#define HAVE_CTIME 1		/* ctime() is present in libc */
/* #undef HAVE_CFTIME */		/* cftime() is present in libc */
/* #undef HAVE_ASCFTIME */		/* ascftime() is present in libc */
#define HAVE_STRFTIME 1		/* strftime() is present in libc */
/* #undef HAVE_GETHRTIME */		/* gethrtime() is present in libc */
#define HAVE_POLL 1		/* poll() is present in libc */
#define HAVE_SELECT 1		/* select() is present in libc */
/* #undef HAVE_ISASTREAM */		/* isastream() is present in libc */
#define HAVE_CHMOD 1		/* chmod() is present in libc */
#define HAVE_FCHMOD 1		/* fchmod() is present in libc */
#define HAVE_LCHMOD 1		/* lchmod() is present in libc */
#define HAVE_CHOWN 1		/* chown() is present in libc */
#define HAVE_FCHOWN 1		/* fchown() is present in libc */
#define HAVE_LCHOWN 1		/* lchown() is present in libc */
#define HAVE_TRUNCATE 1		/* truncate() is present in libc */
#define HAVE_FTRUNCATE 1		/* ftruncate() is present in libc */
#define HAVE_BRK 1			/* brk() is present in libc */
#define HAVE_SBRK 1		/* sbrk() is present in libc */
#define HAVE_VA_COPY 1		/* va_copy() is present in varargs.h/stdarg.h */
#define HAVE__VA_COPY 1		/* __va_copy() is present in varargs.h/stdarg.h */
#define HAVE_DTOA 1		/* BSD-4.4 __dtoa() is present in libc */
/* #undef HAVE_DTOA_R */		/* BSD-4.4 __dtoa() with result ptr (reentrant) */
#define HAVE_DUP 1			/* dup() is present in libc */
#define HAVE_DUP2 1		/* dup2() is present in libc */
#define HAVE_GETCWD 1		/* POSIX getcwd() is present in libc */
/* #undef HAVE_SMMAP */		/* may map anonymous memory to get shared mem */
#define HAVE_SHMAT 1		/* shmat() is present in libc */
/* #undef HAVE_SHMGET */		/* shmget() is present in libc and working */
#define HAVE_SEMGET 1		/* semget() is present in libc */
#define HAVE_LSTAT 1		/* lstat() is present in libc */
#define HAVE_READLINK 1		/* readlink() is present in libc */
#define HAVE_SYMLINK 1		/* symlink() is present in libc */
#define HAVE_LINK 1		/* link() is present in libc */
/* #undef HAVE_HARD_SYMLINKS */	/* link() allows hard links on symlinks */
/* #undef HAVE_LINK_NOFOLLOW */	/* link() does not follow symlinks when hard linking symlinks */
#define HAVE_RENAME 1		/* rename() is present in libc */
#define HAVE_MKFIFO 1		/* mkfifo() is present in libc */
#define HAVE_MKNOD 1		/* mknod() is present in libc */
/* #undef HAVE_ECVT */		/* ecvt() is present in libc */
/* #undef HAVE_FCVT */		/* fcvt() is present in libc */
/* #undef HAVE_GCVT */		/* gcvt() is present in libc */
/* #undef HAVE_ECVT_R */		/* ecvt_r() is present in libc */
/* #undef HAVE_FCVT_R */		/* fcvt_r() is present in libc */
/* #undef HAVE_GCVT_R */		/* gcvt_r() is present in libc */
/* #undef HAVE_QECVT */		/* qecvt() is present in libc */
/* #undef HAVE_QFCVT */		/* qfcvt() is present in libc */
/* #undef HAVE_QGCVT */		/* qgcvt() is present in libc */
/* #undef HAVE__QECVT */		/* _qecvt() is present in libc */
/* #undef HAVE__QFCVT */		/* _qfcvt() is present in libc */
/* #undef HAVE__QGCVT */		/* _qgcvt() is present in libc */
/* #undef HAVE__QECVT_R */		/* _qecvt_r() is present in libc */
/* #undef HAVE__QFCVT_R */		/* _qfcvt_r() is present in libc */
/* #undef HAVE__QGCVT_R */		/* _qgcvt_r() is present in libc */
/* #undef HAVE__LDECVT */		/* _ldecvt() is present in libc */
/* #undef HAVE__LDFCVT */		/* _ldfcvt() is present in libc */
/* #undef HAVE__LDGCVT */		/* _ldgcvt() is present in libc */
/* #undef HAVE__LDECVT_R */		/* _ldecvt_r() is present in libc */
/* #undef HAVE__LDFCVT_R */		/* _ldfcvt_r() is present in libc */
/* #undef HAVE__LDGCVT_R */		/* _ldgcvt_r() is present in libc */
/* #undef HAVE_ECONVERT */		/* econvert() is present in libc */
/* #undef HAVE_FCONVERT */		/* fconvert() is present in libc */
/* #undef HAVE_GCONVERT */		/* gconvert() is present in libc */
/* #undef HAVE_QECONVERT */		/* qeconvert() is present in libc */
/* #undef HAVE_QFCONVERT */		/* qfconvert() is present in libc */
/* #undef HAVE_QGCONVERT */		/* qgconvert() is present in libc */
#define HAVE_ISINF 1		/* isinf() is present in libc */
#define HAVE_ISNAN 1		/* isnan() is present in libc */
#define HAVE_C99_ISINF 1		/* isinf() is present in math.h/libc */
#define HAVE_C99_ISNAN 1		/* isnan() is present in math.h/libc */
#define HAVE_GETC_UNLOCKED 1	/* getc_unlocked() is present in libc */
#define HAVE_GETCHAR_UNLOCKED 1	/* getchar_unlocked() is present in libc */
#define HAVE_PUTC_UNLOCKED 1	/* putc_unlocked() is present in libc */
#define HAVE_PUTCHAR_UNLOCKED 1	/* putchar_unlocked() is present in libc */
#define HAVE_FLOCKFILE 1		/* flockfile() is present in libc */
#define HAVE_FUNLOCKFILE 1		/* funlockfile() is present in libc */
#define HAVE_FTRYLOCKFILE 1	/* ftrylockfile() is present in libc */
/* #undef HAVE_FINITE */		/* finite() is present in libc/ieeefp.h (SVr4) */
/* #undef HAVE_ISNAND */		/* isnand() is present in libc/ieeefp.h (SVr4) */
#define HAVE_RAND 1		/* rand() is present in libc */
#define HAVE_DRAND48 1		/* drand48() is present in libc */
/* #undef HAVE_ICONV_IN_LIBC */	/* whether iconv() is in libc (needs no -liconv) */
/* #undef HAVE_ICONV */		/* iconv() is present in libiconv */
/* #undef HAVE_ICONV_OPEN */		/* iconv_open() is present in libiconv */
/* #undef HAVE_ICONV_CLOSE */		/* iconv_close() is present in libiconc */
/* #undef HAVE_LIBICONV */		/* libiconv() is present in libiconv */
/* #undef HAVE_LIBICONV_OPEN */	/* libiconv_open() is present in liiconv */
/* #undef HAVE_LIBICONV_CLOSE */	/* libiconv_close() is present in libiconv */
#define HAVE_SETPRIORITY 1		/* setpriority() is present in libc */
#define HAVE_NICE 1		/* nice() is present in libc */
/* #undef HAVE_DOSSETPRIORITY */	/* DosSetPriority() is present in libc */
/* #undef HAVE_DOSALLOCSHAREDMEM */	/* DosAllocSharedMem() is present in libc */
#define HAVE_SEEKDIR 1		/* seekdir() is present in libc */
#define HAVE_GETENV 1		/* getenv() is present in libc */
#define HAVE_PUTENV 1		/* putenv() is present in libc (preferred function) */
#define HAVE_SETENV 1		/* setenv() is present in libc (use instead of putenv()) */
#define HAVE_UNSETENV 1		/* unsetenv() is present in libc */
#define HAVE_UNAME 1		/* uname() is present in libc */
#define HAVE_SNPRINTF 1		/* snprintf() is present in libc */
#define HAVE_VPRINTF 1		/* vprintf() is present in libc */
#define HAVE_VFPRINTF 1		/* vfprintf() is present in libc */
#define HAVE_VSPRINTF 1		/* vsprintf() is present in libc */
#define HAVE_VSNPRINTF 1		/* vsnprintf() is present in libc */
#define HAVE_STRCAT 1		/* strcat() is present in libc */
#define HAVE_STRNCAT 1		/* strncat() is present in libc */
/* #undef HAVE_STRCMP */		/* strcmp() is present in libc */
/* #undef HAVE_STRNCMP */		/* strncmp() is present in libc */
#define HAVE_STRCPY 1		/* strcpy() is present in libc */
#define HAVE_STRLCAT 1		/* strlcat() is present in libc */
#define HAVE_STRLCPY 1		/* strlcpy() is present in libc */
#define HAVE_STRNCPY 1		/* strncpy() is present in libc */
/* #undef HAVE_STRDUP */		/* strdup() is present in libc */
/* #undef HAVE_STRNDUP */		/* strndup() is present in libc */
/* #undef HAVE_STRLEN */		/* strlen() is present in libc */
/* #undef HAVE_STRNLEN */		/* strnlen() is present in libc */
/* #undef HAVE_STRCHR */		/* strchr() is present in libc */
/* #undef HAVE_STRRCHR */		/* strrchr() is present in libc */
/* #undef HAVE_STRSTR */		/* strstr() is present in libc */
/* #undef HAVE_STRSPN */		/* strspn() is present in libc */
/* #undef HAVE_STRCSPN */		/* strcspn() is present in libc */
#define HAVE_STRCASECMP 1		/* strcasecmp() is present in libc */
#define HAVE_STRNCASECMP 1		/* strncasecmp() is present in libc */
#define HAVE_BASENAME 1		/* basename() is present in libc */
#define HAVE_DIRNAME 1		/* dirname() is present in libc */
#define HAVE_PATHCONF 1		/* pathconf() is present in libc */
#define HAVE_FPATHCONF 1		/* fpathconf() is present in libc */
/* #undef HAVE_LPATHCONF */		/* lpathconf() is present in libc */
#define HAVE_STRTOL 1		/* strtol() is present in libc */
#define HAVE_STRTOLL 1		/* strtoll() is present in libc */
#define HAVE_STRTOUL 1		/* strtoul() is present in libc */
#define HAVE_STRTOULL 1		/* strtoull() is present in libc */
#define HAVE_STRTOD 1		/* strtold() is present in libc */
#define HAVE_STRSIGNAL 1		/* strsignal() is present in libc */
/* #undef HAVE_STR2SIG */		/* str2sig() is present in libc */
/* #undef HAVE_SIG2STR */		/* sig2str() is present in libc */
#define HAVE_SIGSETJMP 1		/* sigsetjmp() is present in libc */
#define HAVE_SIGLONGJMP 1		/* siglongjmp() is present in libc */
#define HAVE_KILL 1		/* kill() is present in libc */
#define HAVE_KILLPG 1		/* killpg() is present in libc */
#define HAVE_SIGNAL 1		/* signal() is present in libc */
#define HAVE_SIGHOLD 1		/* sighold() is present in libc */
#define HAVE_SIGRELSE 1		/* sigrelse() is present in libc */
#define HAVE_SIGIGNORE 1		/* sigignore() is present in libc */
#define HAVE_SIGPAUSE 1		/* sigpause() is present in libc */
#define HAVE_SIGPROCMASK 1		/* sigprocmask() is present in libc (POSIX) */
#define HAVE_SIGSETMASK 1		/* sigsetmask() is present in libc (BSD) */
#define HAVE_SIGSET 1		/* sigset() is present in libc (POSIX) */
#define HAVE_SIGALTSTACK 1		/* sigaltstack() is present in libc (POSIX) */
#define HAVE_SIGBLOCK 1		/* sigblock() is present in libc (BSD) */
/* #undef HAVE_SYS_SIGLIST */		/* char *sys_siglist[] is present in libc */
#define HAVE_ALARM 1		/* alarm() is present in libc */
#define HAVE_SLEEP 1		/* sleep() is present in libc */
#define HAVE_USLEEP 1		/* usleep() is present in libc */
#define HAVE_FORK 1		/* fork() is present in libc */
/* #undef HAVE_FORKX */		/* forkx() is present in libc */
/* #undef HAVE_FORKALL */		/* forkall() is present in libc */
/* #undef HAVE_FORKALLX */		/* forkallx() is present in libc */
/* #undef HAVE_VFORK */		/* working vfork() is present in libc */
/* #undef HAVE_VFORKX */		/* working vforkx() is present in libc */
#define HAVE_EXECL 1		/* execl() is present in libc */
#define HAVE_EXECLE 1		/* execle() is present in libc */
#define HAVE_EXECLP 1		/* execlp() is present in libc */
#define HAVE_EXECV 1		/* execv() is present in libc */
#define HAVE_EXECVE 1		/* execve() is present in libc */
#define HAVE_EXECVP 1		/* execvp() is present in libc */
/* #undef HAVE_SPAWNL */		/* spawnl() is present in libc */
/* #undef HAVE_SPAWNLE */		/* spawnle() is present in libc */
/* #undef HAVE_SPAWNLP */		/* spawnlp() is present in libc */
/* #undef HAVE_SPAWNLPE */		/* spawnlpe() is present in libc */
/* #undef HAVE_SPAWNV */		/* spawnv() is present in libc */
/* #undef HAVE_SPAWNVE */		/* spawnve() is present in libc */
/* #undef HAVE_SPAWNVP */		/* spawnvp() is present in libc */
/* #undef HAVE_SPAWNVPE */		/* spawnvpe() is present in libc */
#define HAVE_ATEXIT 1		/* atexit() is present in libc */
/* #undef HAVE_ON_EXIT */		/* on_exit() (SunOS-4.x) is present in libc */
/* #undef HAVE_GETEXECNAME */		/* getexecname() is present in libc */
#define HAVE_GETPROGNAME 1		/* getprogname() is present in libc */
#define HAVE_SETPROGNAME 1		/* setprogname() is present in libc */
#define HAVE_PROC_PIDPATH 1	/* proc_pidpath() is present in libc */
/* #undef HAVE_VAR_PROGNAME */	/* extern char *__progname is present in libc */
/* #undef HAVE_VAR_PROGNAME_FULL */	/* extern char *__progname_full is present in libc */
#define HAVE_GETLOADAVG 1		/* getloadavg() is present in libc */
#define HAVE_ALLOCA 1		/* alloca() is present (else use malloc())*/
#define HAVE_MALLOC 1		/* malloc() is present in libc */
#define HAVE_CALLOC 1		/* calloc() is present in libc */
#define HAVE_REALLOC 1		/* realloc() is present in libc */
#define HAVE_REALLOC_NULL 1	/* realloc() implements realloc(NULL, size) */
#define HAVE_VALLOC 1		/* valloc() is present in libc (else use malloc())*/
/* #undef HAVE_MEMALIGN */		/* memalign() is present in libc */
#define HAVE_POSIX_MEMALIGN 1	/* posix_memalign() is present in libc */
#define vfork fork
/* #undef HAVE_WCSCAT */		/* wcscat() is present in libc */
/* #undef HAVE_WCSNCAT */		/* wcsncat() is present in libc */
/* #undef HAVE_WCSCMP */		/* wcscmp() is present in libc */
/* #undef HAVE_WCSNCMP */		/* wcsncmp() is present in libc */
/* #undef HAVE_WCSCPY */		/* wcscpy() is present in libc */
/* #undef HAVE_WCSLCAT */		/* wcsncat() is present in libc */
/* #undef HAVE_WCSLCPY */		/* wcsncpy() is present in libc */
/* #undef HAVE_WCSNCPY */		/* wcsncpy() is present in libc */
/* #undef HAVE_WCSDUP */		/* wcsdup() is present in libc */
/* #undef HAVE_WCSNDUP */		/* wcsndup() is present in libc */
/* #undef HAVE_WCSLEN */		/* wcslen() is present in libc */
/* #undef HAVE_WCSNLEN */		/* wcsnlen() is present in libc */
/* #undef HAVE_WCSCHR */		/* wcschr() is present in libc */
/* #undef HAVE_WCSRCHR */		/* wcsrchr() is present in libc */
/* #undef HAVE_WCSSTR */		/* wcsstr() is present in libc */
/* #undef HAVE_WCSSPN */		/* wcsspn() is present in libc */
/* #undef HAVE_WCSCSPN */		/* wcscspn() is present in libc */
#define HAVE_WCWIDTH 1		/* wcwidth() is present in libc */
#define HAVE_WCSWIDTH 1		/* wcswidth() is present in libc */
#define HAVE_WCTYPE 1		/* wctype() is present in libc */
#define HAVE_ISWCTYPE 1		/* iswctype() is present in libc */


#define HAVE_CHFLAGS 1		/* chflags() is present in libc */
#define HAVE_FCHFLAGS 1		/* fchflags() is present in libc */
#define HAVE_FFLAGSTOSTR 1		/* fflagstostr() is present in libc */
#define HAVE_STRTOFFLAGS 1		/* strtofflags() is present in libc */

#define HAVE_GETTEXT_IN_LIBC 1	/* whether gettext() is in libc (needs no -lintl) */
/* #undef HAVE_GETTEXT */		/* gettext() is present in -lintl */
#define HAVE_SETLOCALE 1		/* setlocale() is present in libc */
#define HAVE_LOCALECONV 1		/* localeconv() is present in libc */
#define HAVE_NL_LANGINFO 1		/* nl_langinfo() is present in libc */

/* #undef HAVE_EXPAT_IN_LIBC */	/* whether XML_Parse() is in libc (needs no -lexpat) */
#define HAVE_XML_PARSE 1		/* whether XML_Parse() libc or -lexpat */

/* #undef HAVE_PCSC_IN_LIBC */	/* whether SCardEstablishContext() is in libc (needs no -lpcsclite) */
/* #undef HAVE_SCARDESTABLISHCONTEXT */	/* whether SCardEstablishContext() libc or -lpcsclite */

/* #undef HAVE_CRYPTO_IN_LIBC */	/* whether CRYPTO_free() is in libc (needs no -lcrypto) */
/* #undef HAVE_CRYPTO_FREE */		/* whether CRYPTO_free() libc or -lcrypto */

/* #undef HAVE_SSL_IN_LIBC */		/* whether SSL_free() is in libc (needs no -lssl) */
/* #undef HAVE_SSL_FREE */		/* whether SSL_free() libc or -lssl */

#define HAVE_SETBUF 1		/* setbuf() is present in libc */
#define HAVE_SETVBUF 1		/* setvbuf() is present in libc */

#define HAVE_FNMATCH 1		/* fnmatch() is present in libc */
/* #undef HAVE_FNMATCH_IGNORECASE */	/* fnmatch() implements FNM_IGNORECASE */

#define HAVE_MKTEMP 1		/* mktemp() is present in libc */
#define HAVE_MKSTEMP 1		/* mkstemp() is present in libc */

/* #undef HAVE_GETPPRIV */		/* getppriv() is present in libc */
/* #undef HAVE_SETPPRIV */		/* setppriv() is present in libc */
/* #undef HAVE_PRIV_SET */		/* priv_set() is present in libc */
#define HAVE_ISSETUGID 1		/* issetugid() is present in libc */
/* #undef HAVE_GETROLES */		/* getroles() is present in libc (AIX) */
/* #undef HAVE_PRIVBIT_SET */		/* privbit_set() is present in libc (AIX) */

/* #undef HAVE_GETAUTHATTR */		/* getauthattr() is present in -lsecdb */
/* #undef HAVE_GETUSERATTR */		/* getuserattr() is present in -lsecdb */
/* #undef HAVE_GETEXECATTR */		/* getexecattr() is present in -lsecdb */
/* #undef HAVE_GETPROFATTR */		/* getprofattr() is present in -lsecdb */

/* #undef HAVE_GMATCH */		/* gmatch() is present in -lgen */

/* #undef HAVE_ELF_BEGIN */		/* elf_begin() is present in -lelf */

/* #undef HAVE_CLONE_AREA */		/* clone_area() is present in libc */
/* #undef HAVE_CREATE_AREA */		/* create_area() is present in libc */
/* #undef HAVE_DELETE_AREA */		/* delete_area() is present in libc */

/* #undef HAVE_RES_INIT_IN_LIBC */	/* whether res_init() is in libc (needs no -lresolv) */

#define HAVE_DLOPEN_IN_LIBC 1	/* whether dlopen() is in libc (needs no -ldl) */
#define HAVE_DLOPEN 1		/* dlopen() is present in libc */
#define HAVE_DLCLOSE 1		/* dlclose() is present in libc */
#define HAVE_DLSYM 1		/* dlsym() is present in libc */
#define HAVE_DLERROR 1		/* dlerror() is present in libc */
/* #undef HAVE_DLINFO */		/* dlinfo() is present in libc */
/* #undef HAVE_SHL_LOAD */		/* shl_load() is present in libc */
/* #undef HAVE_SHL_UNLOAD */		/* shl_unload() is present in libc */
/* #undef HAVE_SHL_GETHANDLE */	/* shl_gethandle() is present in libc */
/* #undef HAVE_LOADLIBRARY */		/* LoadLibrary() as present in libc */
/* #undef HAVE_FREELIBRARY */		/* FreeLibrary() is present in libc */
/* #undef HAVE_GETPROCADDRESS */	/* GetProcAddress() is present in libc */

/* #undef HAVE_YIELD */		/* yield() is present in libc */
/* #undef HAVE_THR_YIELD */		/* thr_yield() is present in libc */

#define HAVE_PTHREAD_CREATE 1	/* pthread_create() is present in libpthread */
#define HAVE_PTHREAD_KILL 1	/* pthread_kill() is present in libpthread */
#define HAVE_PTHREAD_MUTEX_LOCK 1	/* pthread_mutex_lock() is present in libpthread */
#define HAVE_PTHREAD_COND_WAIT 1	/* pthread_cond_wait() is present in libpthread */
/* #undef HAVE_PTHREAD_SPIN_LOCK */	/* pthread_spin_lock() is present in libpthread */

#define HAVE_CLOCK_GETTIME_IN_LIBC 1 /* whether clock_gettime() is in libc (needs no -lrt) */
#define HAVE_CLOCK_GETTIME 1	/* clock_gettime() is present in librt */
#define HAVE_CLOCK_SETTIME 1	/* clock_settime() is present in librt */
#define HAVE_CLOCK_GETRES 1	/* clock_getres() is present in librt */
/* #undef HAVE_SCHED_GETPARAM */	/* sched_getparam() is present in librt */
/* #undef HAVE_SCHED_SETPARAM */	/* sched_setparam() is present in librt */
/* #undef HAVE_SCHED_GETSCHEDULER */	/* sched_getscheduler() is present in librt */
/* #undef HAVE_SCHED_SETSCHEDULER */	/* sched_setscheduler() is present in librt */
#define HAVE_SCHED_YIELD 1		/* sched_yield() is present in librt */
#define HAVE_NANOSLEEP 1		/* nanosleep() is present in librt */

/*
 * The POSIX.1e draft has been withdrawn in 1997.
 * Linux started to implement this outdated concept in 1997.
 */
/* #undef HAVE_CAP_GET_PROC */	/* cap_get_proc() is present in libcap */
/* #undef HAVE_CAP_SET_PROC */	/* cap_set_proc() is present in libcap */
/* #undef HAVE_CAP_SET_FLAG */	/* cap_set_flag() is present in libcap */
/* #undef HAVE_CAP_CLEAR_FLAG */	/* cap_clear_flag() is present in libcap */


/* #undef HAVE_DIRFD */		/* dirfd() is present in libc */
/* #undef HAVE_ISWPRINT */		/* iswprint() is present in libc */
/* #undef HAVE_ISWBLANK */		/* iswblank() is present in libc */
/* #undef HAVE_ISBLANK */		/* isblank() is present in libc */
/* #undef HAVE_MBSINIT */		/* mbsinit() is present in libc */
#define HAVE_MBTOWC 1		/* mbtowc() is present in libc */
#define HAVE_WCTOMB 1		/* wctomb() is present in libc */
/* #undef HAVE_MBRTOWC */		/* mbrtowc() is present in libc */
/* #undef HAVE_WCRTOMB */		/* wcrtomb() is present in libc */

/* #undef HAVE_PRINTF_J */		/* *printf() in libc supports %jd */
/* #undef HAVE_PRINTF_Z */		/* *printf() in libc supports %zd */
/* #undef HAVE_PRINTF_LL */		/* *printf() in libc supports %lld */

/*
 * Functions that we defined in 1982 but where POSIX.1-2008 defined
 * a POSIX violating incompatible definition.
 * We use AC_RCHECK_FUNCS(), so we get HAVE_RAW_* results as some
 * Linux distros have fexecve() that returns ENOSYS.
 */
/* #undef HAVE_RAW_FEXECL */		/* fexecl() */
/* #undef HAVE_RAW_FEXECLE */		/* fexecle() */
/* #undef HAVE_RAW_FEXECV */		/* fexecv() */
/* #undef HAVE_RAW_FEXECVE */		/* fexecve() */
/* #undef HAVE_RAW_FSPAWNV */		/* fspawnv() */
/* #undef HAVE_RAW_FSPAWNL */		/* fspawnl() */
/* #undef HAVE_RAW_FSPAWNV_NOWAIT */	/* fspawnv_nowait() */
#define HAVE_RAW_GETLINE 1		/* getline() */
/* #undef HAVE_RAW_FGETLINE */	/* fgetline() */


/*
 * Misc OS stuff
 */
				/* Dirty hack, better use C program not test */
#if !defined(_MSC_VER) && !defined(__MINGW32__)
/* #undef HAVE__DEV_TTY */		/* /dev/tty present */
#define HAVE__DEV_NULL 1		/* /dev/null present */
/* #undef HAVE__DEV_ZERO */		/* /dev/zero present */
/* #undef HAVE__DEV_STDIN */		/* /dev/stdin present */
/* #undef HAVE__DEV_STDOUT */		/* /dev/stdout present */
/* #undef HAVE__DEV_STDERR */		/* /dev/stderr present */
/* #undef HAVE__DEV_FD_0 */		/* /dev/fd/0 present */
/* #undef HAVE__DEV_FD_1 */		/* /dev/fd/1 present */
/* #undef HAVE__DEV_FD_2 */		/* /dev/fd/2 present */
/* #undef HAVE__USR_SRC_LINUX_INCLUDE */	/* /usr/src/linux/include present */
/* #undef HAVE__USR_XPG4_BIN_SH */	/* /usr/xpg4/bin/sh present */
/* #undef HAVE__OPT_SCHILY_XPG4_BIN_SH */	/* /opt/schily/xpg4/bin/sh present */
#endif

/*
 * Misc OS programs
 */
#define	SHELL_IS_BASH 1		/* sh is bash */
#define	BIN_SHELL_IS_BASH 1	/* /bin/sh is bash */
/* #undef	SHELL_CE_IS_BROKEN */	/* sh -ce is broken */
/* #undef	BIN_SHELL_CE_IS_BROKEN */	/* /bin/sh -ce is broken */
/* #undef	BIN_SHELL_BOSH */		/* /bin/bosh is a working Bourne Shell */
/* #undef	OPT_SCHILY_BIN_SHELL_BOSH */ /* /opt/schily/bin/bosh is a working Bourne Shell */

/*
 * OS madness
 */
/* #undef HAVE_BROKEN_LINUX_EXT2_FS_H */	/* whether <linux/ext2_fs.h> is broken */
/* #undef HAVE_BROKEN_SRC_LINUX_EXT2_FS_H */	/* whether /usr/src/linux/include/linux/ext2_fs.h is broken */
/* #undef HAVE_USABLE_LINUX_EXT2_FS_H */	/* whether linux/ext2_fs.h is usable at all */
/* #undef HAVE_BROKEN_SCSI_SCSI_H */		/* whether <scsi/scsi.h> is broken */
/* #undef HAVE_BROKEN_SRC_SCSI_SCSI_H */	/* whether /usr/src/linux/include/scsi/scsi.h is broken */
/* #undef HAVE_BROKEN_SCSI_SG_H */		/* whether <scsi/sg.h> is broken */
/* #undef HAVE_BROKEN_SRC_SCSI_SG_H */	/* whether /usr/src/linux/include/scsi/sg.h is broken */

/*
 * Linux Extended File Attributes
 */
/* #undef HAVE_GETXATTR */		/* getxattr()				*/
/* #undef HAVE_SETXATTR */		/* setxattr()				*/
/* #undef HAVE_LISTXATTR */		/* listxattr()				*/
/* #undef HAVE_LGETXATTR */		/* lgetxattr()				*/
/* #undef HAVE_LSETXATTR */		/* lsetxattr()				*/
/* #undef HAVE_LLISTXATTR */		/* llistxattr()				*/

/*
 * Important:	This must be a result from a check _before_ the Large File test
 *		has been run. It then tells us whether these functions are
 *		available even when not in Large File mode.
 *
 *	Do not run the AC_FUNC_FSEEKO test from the GNU tar Large File test
 *	siute. It will use the same cache names and interfere with our test.
 *	Instead use the tests AC_SMALL_FSEEKO/AC_SMALL/STELLO and make sure
 *	they are placed before the large file tests.
 */
#define HAVE_FSEEKO 1		/* fseeko() is present in default compile mode */
#define HAVE_FTELLO 1		/* ftello() is present in default compile mode */

#define HAVE_RCMD 1		/* rcmd() is present in libc/libsocket */
#define HAVE_SOCKET 1		/* socket() is present in libc/libsocket */
#define HAVE_SOCKETPAIR 1		/* socketpair() is present in libc/libsocket */
#define HAVE_GETSERVBYNAME 1	/* getservbyname() is present in libc/libsocket */
#define HAVE_INET_NTOA 1		/* inet_ntoa() is present in libc/libsocket */
#define HAVE_GETADDRINFO 1		/* getaddrinfo() is present in libc/libsocket */
#define HAVE_GETNAMEINFO 1		/* getnameinfo() is present in libc/libsocket */
/* #undef HAVE_HOST2NETNAME */	/* host2netname() is present in libc/libsocket */
/* #undef HAVE_NETNAME2HOST */	/* netname2host() is present in libc/libsocket */


#if	defined(HAVE_QUOTACTL) || defined(HAVE_QUOTAIOCTL)
#	define HAVE_QUOTA	/* The system inludes quota */
#endif

/*
 * We need to test for the include files too because Apollo Domain/OS has a
 * libc that includes the functions but the includes files are not visible
 * from the BSD compile environment.
 *
 * ATARI MiNT has a non-working shmget(), so we test for it separately.
 */
#if	defined(HAVE_SHMAT) && defined(HAVE_SHMGET) && \
	defined(HAVE_SYS_SHM_H) && defined(HAVE_SYS_IPC_H)
#	define	HAVE_USGSHM	/* USG shared memory is present */
#endif
#if	defined(HAVE_SEMGET) && defined(HAVE_SYS_SHM_H) && defined(HAVE_SYS_IPC_H)
#	define	HAVE_USGSEM	/* USG semaphores are present */
#endif

#if	defined(HAVE_GETPGRP) && !defined(HAVE_BSD_GETPGRP)
#define	HAVE_POSIX_GETPGRP 1	/* getpgrp() in libc is POSIX compliant */
#endif
#if	defined(HAVE_SETPGRP) && !defined(HAVE_BSD_SETPGRP)
#define	HAVE_POSIX_SETPGRP 1	/* setpgrp() in libc is POSIX compliant */
#endif

/*
 * Structures
 */
#define HAVE_FILE__FLAGS 1		/* if FILE * contains _flags */
/* #undef HAVE_FILE__IO_BUF_BASE */	/* if FILE * contains _IO_buf_base */

/* #undef HAVE_MTGET_TYPE */		/* if struct mtget contains mt_type (drive type) */
/* #undef HAVE_MTGET_MODEL */		/* if struct mtget contains mt_model (drive type) */
/* #undef HAVE_MTGET_DSREG */		/* if struct mtget contains mt_dsreg (drive status) */
/* #undef HAVE_MTGET_DSREG1 */	/* if struct mtget contains mt_dsreg1 (drive status msb) */
/* #undef HAVE_MTGET_DSREG2 */	/* if struct mtget contains mt_dsreg2 (drive status lsb) */
/* #undef HAVE_MTGET_GSTAT */		/* if struct mtget contains mt_gstat (generic status) */
/* #undef HAVE_MTGET_ERREG */		/* if struct mtget contains mt_erreg (error register) */
/* #undef HAVE_MTGET_RESID */		/* if struct mtget contains mt_resid (residual count) */
/* #undef HAVE_MTGET_FILENO */	/* if struct mtget contains mt_fileno (file #) */
/* #undef HAVE_MTGET_BLKNO */		/* if struct mtget contains mt_blkno (block #) */
/* #undef HAVE_MTGET_FLAGS */		/* if struct mtget contains mt_flags (flags) */
/* #undef HAVE_MTGET_BF */		/* if struct mtget contains mt_bf (optimum blocking factor) */
#define HAVE_STRUCT_TIMEVAL 1	/* have struct timeval in time.h or sys/time.h */
#define HAVE_STRUCT_TIMEZONE 1	/* have struct timezone in time.h or sys/time.h */
#define HAVE_STRUCT_TIMESPEC 1	/* have struct timespec in time.h or sys/time.h */
#define HAVE_STRUCT_RUSAGE 1	/* have struct rusage in sys/resource.h */
/* #undef HAVE_SI_UTIME */		/* if struct siginfo contains si_utime */
#define HAVE_UNION_SEMUN 1		/* have an illegal definition for union semun in sys/sem.h */
#define HAVE_UNION_WAIT 1		/* have union wait in wait.h */
/* #undef USE_UNION_WAIT */		/* union wait in wait.h is used by default */
#define HAVE_DIRENT_D_INO 1	/* have d_ino in struct dirent */
#define HAVE_DIRENT_D_TYPE 1	/* have d_type in struct dirent */
/* #undef HAVE_DIR_DD_FD */		/* have dd_fd in DIR * */
/*
 * SCO UnixWare has st_atim.st__tim.tv_nsec but the st_atim.tv_nsec tests also
 * succeeds. If you use st_atim.tv_nsec on UnixWare, you get a warning about
 * illegal structure usage. For this reason, your code needs to have
 * #ifdef HAVE_ST__TIM before #ifdef HAVE_ST_NSEC.
 */
/* #undef HAVE_ST_SPARE1 */		/* if struct stat contains st_spare1 (usecs) */
/* #undef HAVE_ST_ATIMENSEC */	/* if struct stat contains st_atimensec (nanosecs) */
/* #undef HAVE_ST_ATIME_N */		/* if struct stat contains st_atime_n (nanosecs) */
/* #undef HAVE_ST_NSEC */		/* if struct stat contains st_atim.tv_nsec (nanosecs) */
/* #undef HAVE_ST__TIM */		/* if struct stat contains st_atim.st__tim.tv_nsec (nanosecs) */
#define HAVE_ST_ATIMESPEC 1	/* if struct stat contains st_atimespec.tv_nsec (nanosecs) */
#define HAVE_ST_BLKSIZE 1		/* if struct stat contains st_blksize */
#define HAVE_ST_BLOCKS 1		/* if struct stat contains st_blocks */
/* #undef HAVE_ST_FSTYPE */		/* if struct stat contains st_fstype */
/* #undef HAVE_ST_ACLCNT */		/* if struct stat contains st_aclcnt */
#define HAVE_ST_RDEV 1		/* if struct stat contains st_rdev */
/* #undef HAVE_ST_FLAG */		/* if struct stat contains st_flag */
#define HAVE_ST_FLAGS 1		/* if struct stat contains st_flags */
/* #undef STAT_MACROS_BROKEN */	/* if the macros S_ISDIR, S_ISREG .. don't work */

/* #undef HAVE_UTSNAME_ARCH */	/* if struct utsname contains processor as arch */
/* #undef HAVE_UTSNAME_PROCESSOR */	/* if struct utsname contains processor */
/* #undef HAVE_UTSNAME_SYSNAME_HOST */ /* if struct utsname contains sysname_host */
/* #undef HAVE_UTSNAME_RELEASE_HOST */ /* if struct utsname contains release_host */
/* #undef HAVE_UTSNAME_VERSION_HOST */ /* if struct utsname contains version_host */

#define DEV_MINOR_BITS 0		/* # if bits needed to hold minor device number */
/* #undef DEV_MINOR_NONCONTIG */	/* if bits in minor device number are noncontiguous */

/* #undef HAVE_SOCKADDR_STORAGE */	/* if socket.h defines struct sockaddr_storage */


/*
 * Byteorder/Bitorder
 */
#define	HAVE_C_BIGENDIAN	/* Flag that WORDS_BIGENDIAN test was done */
/* #undef WORDS_BIGENDIAN */		/* If using network byte order             */
#define	HAVE_C_BITFIELDS	/* Flag that BITFIELDS_HTOL test was done  */
/* #undef BITFIELDS_HTOL */		/* If high bits come first in structures   */

/*
 * Types/Keywords
 */
#define SIZEOF_CHAR 0
#define SIZEOF_SHORT_INT 0
#define SIZEOF_INT 0
#define SIZEOF_LONG_INT 0
#define SIZEOF_LONG_LONG 0
#define SIZEOF___INT64 0
#define SIZEOF_CHAR_P 0
#define SIZEOF_UNSIGNED_CHAR 0
#define SIZEOF_UNSIGNED_SHORT_INT 0
#define SIZEOF_UNSIGNED_INT 0
#define SIZEOF_UNSIGNED_LONG_INT 0
#define SIZEOF_UNSIGNED_LONG_LONG 0
#define SIZEOF_UNSIGNED___INT64 0
#define SIZEOF_UNSIGNED_CHAR_P 0
#define SIZEOF_FLOAT 0
#define SIZEOF_DOUBLE 0
#define SIZEOF_LONG_DOUBLE 0

#define SIZEOF_SIZE_T 0
#define SIZEOF_SSIZE_T 0
#define SIZEOF_PTRDIFF_T 0

#define SIZEOF_MODE_T 0
#define SIZEOF_UID_T 0
#define SIZEOF_GID_T 0
#define SIZEOF_PID_T 0

/*
 * If sizeof (mode_t) is < sizeof (int) and used with va_arg(),
 * GCC4 will abort the code. So we need to use the promoted size.
 */
#if	SIZEOF_MODE_T < SIZEOF_INT
#define	PROMOTED_MODE_T	int
#else
#define	PROMOTED_MODE_T	mode_t
#endif

#define SIZEOF_DEV_T 0
#define SIZEOF_MAJOR_T 0
#define SIZEOF_MINOR_T 0

#define SIZEOF_TIME_T SIZEOF_LONG_INT
#define SIZEOF_WCHAR 0		/* sizeof (L'a')	*/
#define SIZEOF_WCHAR_T 4		/* sizeof (wchar_t)	*/

#define HAVE_LONGLONG 1		/* Compiler defines long long type */
/* #undef HAVE___INT64 */		/* Compiler defines __int64 type */
#define HAVE_LONGDOUBLE 1		/* Compiler defines long double type */
/* #undef CHAR_IS_UNSIGNED */		/* Compiler defines char to be unsigned */

/* #undef const */			/* Define to empty if const doesn't work */
/* #undef uid_t */			/* To be used if uid_t is not present  */
/* #undef gid_t */			/* To be used if gid_t is not present  */
/* #undef size_t */			/* To be used if size_t is not present */
/* #undef ssize_t */			/* To be used if ssize_t is not present */
/* #undef ptrdiff_t */		/* To be used if ptrdiff_t is not present */
/* #undef pid_t */			/* To be used if pid_t is not present  */
/* #undef off_t */			/* To be used if off_t is not present  */
/* #undef mode_t */			/* To be used if mode_t is not present */
/* #undef time_t */			/* To be used if time_t is not present */
/* #undef caddr_t */			/* To be used if caddr_t is not present */
/* #undef daddr_t */			/* To be used if daddr_t is not present */
/* #undef dev_t */			/* To be used if dev_t is not present */
#define major_t dev_t			/* To be used if major_t is not present */
#define minor_t dev_t			/* To be used if minor_t is not present */
/* #undef ino_t */			/* To be used if ino_t is not present */
/* #undef nlink_t */			/* To be used if nlink_t is not present */
/* #undef blksize_t */		/* To be used if blksize_t is not present */
/* #undef blkcnt_t */			/* To be used if blkcnt_t is not present */

#define	HAVE_TYPE_INTMAX_T 1	/* if <stdint.h> defines intmax_t */
#define	HAVE_TYPE_UINTMAX_T 1	/* if <stdint.h> defines uintmax_t */

/* #undef int8_t */			/* To be used if int8_t is not present */
/* #undef int16_t */			/* To be used if int16_t is not present */
/* #undef int32_t */			/* To be used if int32_t is not present */
#if	defined(HAVE_LONGLONG) || defined(HAVE___INT64)
/* #undef int64_t */			/* To be used if int64_t is not present */
#endif
/* #undef intmax_t */			/* To be used if intmax_t is not present */
/* #undef uint8_t */			/* To be used if uint8_t is not present */
/* #undef uint16_t */			/* To be used if uint16_t is not present */
/* #undef uint32_t */			/* To be used if uint32_t is not present */
#if	defined(HAVE_LONGLONG) || defined(HAVE___INT64)
/* #undef uint64_t */			/* To be used if uint64_t is not present */
#endif
/* #undef uintmax_t */		/* To be used if uintmax_t is not present */

/* #undef	HAVE_TYPE_GREG_T */	/* if <sys/frame.h> defines greg_t */

#define	HAVE_TYPE_RLIM_T 1	/* if <sys/resource.h> defines rlim_t */
/* #undef	HAVE_TYPE_IDTYPE_T */	/* if <sys/wait.h> defines idtype_t */
#define	HAVE_TYPE_SIGINFO_T 1	/* if <sys/wait.h> defines siginfo_t */

/* #undef	HAVE_STACK_T */		/* if <signal.h> defines stack_t */
/* #undef	HAVE_SIGINFO_T */		/* if <signal.h> defines siginfo_t */

/*
 * Important:	Next Step needs time.h for clock_t (because of a bug)
 */
/* #undef clock_t */			/* To be used if clock_t is not present */
/* #undef socklen_t */		/* To be used if socklen_t is not present */

/*
 * These types are present on all UNIX systems but should be avoided
 * for portability.
 * On Apollo/Domain OS we don't have them....
 *
 * Better include <schily/utypes.h> and use Uchar, Uint & Ulong
 */
/* #undef u_char */			/* To be used if u_char is not present	*/
/* #undef u_short */			/* To be used if u_short is not present	*/
/* #undef u_int */			/* To be used if u_int is not present	*/
/* #undef u_long */			/* To be used if u_long is not present	*/

/* #undef wctype_t */			/* To be used if wctype_t is not in wchar.h */
/* #undef wint_t */			/* To be used if wint_t is not in wchar.h */
/* #undef mbstate_t */		/* To be used if mbstate_t is not in wchar.h */

#define timestruc_t timespec		/* To be used if timestruc_t is not in sys/stat.h */

/*#undef HAVE_SIZE_T*/
/*#undef NO_SIZE_T*/
#ifdef __x86_64__
#define VA_LIST_IS_ARRAY 1		/* va_list is an array */
#endif
#define GETGROUPS_T int
#define GID_T		GETGROUPS_T

/*
 * Define as the return type of signal handlers (int or void).
 */
#define RETSIGTYPE void

/*
 * Defined in case that we have iconv(iconv_t, const char **, site_t *, ...)
 */
/* #undef HAVE_ICONV_CONST */

/*
 * Defines needed to get large file support.
 */
#ifdef	USE_LARGEFILES

#define	HAVE_LARGEFILES 1

#ifdef	HAVE_LARGEFILES		/* If we have working largefiles at all	   */
				/* This is not defined with glibc-2.1.3	   */

/* #undef _FILE_OFFSET_BITS */	/* # of bits in off_t if settable	   */
/* #undef _LARGEFILE_SOURCE */	/* To make ftello() visible (HP-UX 10.20). */
/* #undef _LARGE_FILES */		/* Large file defined on AIX-style hosts.  */
/* #undef _XOPEN_SOURCE */		/* To make ftello() visible (glibc 2.1.3). */
				/* XXX We don't use this because glibc2.1.3*/
				/* XXX is bad anyway. If we define	   */
				/* XXX _XOPEN_SOURCE we will loose caddr_t */

#define HAVE_FSEEKO 1		/* Do we need this? If HAVE_LARGEFILES is  */
				/* defined, we have fseeko()		   */

#endif	/* HAVE_LARGEFILES */
#endif	/* USE_LARGEFILES */

#ifdef USE_ACL			/* Enable/disable ACL support */
/*
 * The withdrawn POSIX.1e ACL draft support.
 * It has been written in 1993 and withdrawn in 1997.
 * Linux started to implement it in 2001.
 */
#define HAVE_ACL_GET_FILE 1	/* acl_get_file() function */
#define HAVE_ACL_SET_FILE 1	/* acl_set_file() function */
#define HAVE_ACL_GET_ENTRY 1	/* acl_get_entry() function */
#define HAVE_ACL_FROM_TEXT 1	/* acl_from_text() function */
#define HAVE_ACL_TO_TEXT 1		/* acl_to_text() function */
/* #undef HAVE_ACL_TO_TEXT_NP */	/* acl_to_text_np() function */
/* #undef HAVE_ACL_GET_BRAND_NP */	/* acl_get_brand_np() function */
/* #undef HAVE_ACL_IS_TRIVIAL_NP */	/* acl_is_trivial_np() function */
/* #undef HAVE_ACL_STRIP_NP */	/* acl_strip_np() function */
#define HAVE_ACL_FREE 1		/* acl_free() function */
#define HAVE_ACL_DELETE_DEF_FILE 1	/* acl_delete_def_file() function */
/* #undef HAVE_ACL_EXTENDED_FILE */	/* acl_extended_file() function (Linux only)*/

#if defined(HAVE_ACL_GET_FILE) && defined(HAVE_ACL_SET_FILE) && \
    defined(HAVE_ACL_FROM_TEXT) && defined(HAVE_ACL_TO_TEXT) && \
    defined(HAVE_ACL_FREE)
#	define	HAVE_POSIX_ACL	1 /* Withdrawn POSIX draft ACL's present */
#endif

/*
 * Sun UFS ACL support.
 * Note: unfortunately, HP-UX has an (undocumented) acl() function in libc.
 */
/* #undef HAVE_ACL */			/* acl() function */
/* #undef HAVE_FACL */		/* facl() function */
/* #undef HAVE_ACLFROMTEXT */		/* aclfromtext() function */
/* #undef HAVE_ACLTOTEXT */		/* acltotext() function */

/*
 * NFSv4 ACL support.
 * Note: There is an unfortunate name clash for acl_free() with the
 *	 withdrawn POSIX.1e draft. We correct this below.
 */
/* #undef HAVE_ACL_GET */		/* acl_get() function */
/* #undef HAVE_ACL_SET */		/* acl_set() function */
/* #undef HAVE_FACL_GET */		/* facl_get() function */
/* #undef HAVE_FACL_SET */		/* facl_set() function */
/* #undef HAVE_ACL_FROMTEXT */	/* acl_fromtext() function */
/* #undef HAVE_ACL_TOTEXT */		/* acl_totext() function */

#if !defined(HAVE_POSIX_ACL)
/*
 * Cygwin used to implement the Sun UFS ACL interface but in 2016
 * moved towards the withdrawn POSIX draft.
 * Make sure that we do not #define HAVE_POSIX_ACL and HAVE_SUN_ACL
 * at the same time.
 */
#if defined(HAVE_ACL) && defined(HAVE_FACL) && \
    defined(HAVE_ACLFROMTEXT) && defined(HAVE_ACLTOTEXT)
#	define	HAVE_SUN_ACL	1 /* Sun UFS ACL's present */
#endif
#endif /* !defined(HAVE_POSIX_ACL) */

#if defined(HAVE_ACL_GET) && defined(HAVE_ACL_SET) && \
    defined(HAVE_FACL_GET) && defined(HAVE_FACL_SET) && \
    defined(HAVE_ACL_FROMTEXT) && defined(HAVE_ACL_TOTEXT)
#	define	HAVE_ACL_FREE	1 /* acl_fre() function */
#	define	HAVE_NFSV4_ACL	1 /* NFSv4 ACL's present */
#endif

#if defined(HAVE_ACL_GET_BRAND_NP)
#ifndef	HAVE_NFSV4_ACL
#	define	HAVE_NFSV4_ACL	1 /* NFSv4 ACL's present */
#endif
#	define	HAVE_FREEBSD_NFSV4_ACL	1 /* FreeBSD NFSv4 ACL implementation */
#endif

/*
 * HP-UX ACL support.
 * Note: unfortunately, HP-UX has an (undocumented) acl() function in libc.
 */
/* #undef HAVE_GETACL */		/* getacl() function */
/* #undef HAVE_FGETACL */		/* fgetacl() function */
/* #undef HAVE_SETACL */		/* setacl() function */
/* #undef HAVE_FSETACL */		/* fsetacl() function */
/* #undef HAVE_STRTOACL */		/* strtoacl() function */
/* #undef HAVE_ACLTOSTR */		/* acltostr() function */
/* #undef HAVE_CPACL */		/* cpacl() function */
/* #undef HAVE_FCPACL */		/* fcpacl() function */
/* #undef HAVE_CHOWNACL */		/* chownacl() function */
/* #undef HAVE_SETACLENTRY */		/* setaclentry() function */
/* #undef HAVE_FSETACLENTRY */	/* fsetaclentry() function */

#if defined(HAVE_GETACL) && defined(HAVE_FGETACL) && \
    defined(HAVE_SETACL) && defined(HAVE_FSETACL) && \
    defined(HAVE_STRTOACL) && defined(HAVE_ACLTOTEXT)
#	define	HAVE_HP_ACL	1 /* HP-UX ACL's present */
#endif

/*
 * Global definition whether ACL support is present.
 * As HP-UX differs too much from other implementations, HAVE_HP_ACL is not
 * included in HAVE_ANY_ACL.
 */
#if defined(HAVE_POSIX_ACL) || defined(HAVE_SUN_ACL) || defined(HAVE_NFSV4_ACL)
#	define	HAVE_ANY_ACL	1 /* Any ACL implementation present */
#endif

#endif	/* USE_ACL */

/*
 * Misc CC / LD related stuff
 */
#define NO_USER_MALLOC 1		/* If we cannot define our own malloc()	*/
/* #undef NO_USER_XCVT */		/* If we cannot define our own ecvt()/fcvt()/gcvt() */
#define HAVE_DYN_ARRAYS 1		/* If the compiler allows dynamic sized arrays */
/* #undef HAVE_PRAGMA_WEAK */		/* If the compiler allows #pragma weak */
/* #undef HAVE_LINK_WEAK */		/* If the linker sees weak entries in other files */
#define HAVE_STRINGIZE 1		/* If the cpp supports ANSI C stringize */
/* #undef inline */

/*
 * Strings that help to maintain OS/platform id's in C-programs
 */
#define HOST_ALIAS "unknownCPU-unknownMFR-unknownOS"		/* Output from config.guess (orig)	*/
#define HOST_SUB ""			/* Output from config.sub (modified)	*/
#define HOST_CPU ""			/* CPU part from HOST_SUB		*/
#define HOST_VENDOR ""		/* VENDOR part from HOST_SUB		*/
#define HOST_OS ""			/* CPU part from HOST_SUB		*/


/*
 * Begin restricted code for quality assurance.
 *
 * Warning: you are not allowed to include the #define below if you are not
 * using the Schily makefile system or if you modified the autoconfiguration
 * tests.
 *
 * If you only added other tests you are allowed to keep this #define.
 *
 * This restiction is introduced because this way, I hope that people
 * contribute to the project instead of creating branches.
 */
#define	IS_SCHILY_XCONFIG
/*
 * End restricted code for quality assurance.
 */

#endif	/* __XCONFIG_H */
