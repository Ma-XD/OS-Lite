# Отчет по лабораторной работе 5

## Эксперимент 1

### Данные о текущей конфигурации операционной системы

* Общий объем оперативной памяти: **3924 MиБ (4018208 kB)**
* Объем раздела подкачки **1710 MиБ (1751040 kB)**
* Размер страницы виртуальной памяти: **4096 b**
* Объем свободной физической памяти в ненагруженной системе: ~**3000 MиБ (3072000 kB)**
* Объем свободного пространства в разделе подкачки в ненагруженной системе: ~**1000 MиБ (1024000kB)**

### Первый этап

*Файл spy.report содержит подробные изменения отслеживаемых строк в top за каждую секунду* 
	  
#### Размер массива перед падением

* Size=**54_000_000**

#### Последние записи в системном журнале	  
	  
	[ 9060.994841] oom-kill:
	constraint=CONSTRAINT_NONE,
	nodemask=(null),
	cpuset=/,
	mems_allowed=0,
	global_oom,
	task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.Terminal.slice/vte-spawn-cd032f06-7fc2-49ba-ba99-f8cac1aeb816.scope,
	task=bash,
	pid=7534,
	uid=0
	
	[ 9060.994859] Out of memory:Killed process 7534 (bash)
	total-vm:4247244kB,
	anon-rss:3183412kB, 
	file-rss:0kB, 
	shmem-rss:0kB, 
	UID:0 
	pgtables:8340kB 
	oom_score_adj:0
	
#### Наблюдение за топ.

* С начала работы скрипта сьедалась свободная физическая память. Сам скрипт находился в топе по памяти и процессорному времени. 

	МиБ Mem :   3924,0 total,   2697,5 free,    817,3 used,    409,3 buff/cache
	 МиБ Swap:   1710,0 total,   1117,3 free,    592,7 used.   2800,9 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   5477 root      20   0  139404 124224   3312 R 100,0   3,1   0:08.22 bash
	      1 root      20   0  166748   8416   5152 S   0,0   0,2   0:22.60 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+

* Когда свободная физическаяпамять заканчивалась (достигла 100 МиБ), начинала уменьшаться память раздела подкачки.

	МиБ Mem :   3924,0 total,    103,6 free,   3689,3 used,    131,2 buff/cache
	МиБ Swap:   1710,0 total,    958,9 free,    751,1 used.     28,8 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   5477 root      20   0 3187680   3,0g   2644 R  93,8  77,2   3:34.91 bash
	      1 root      20   0  166748   6760   3524 S   0,0   0,2   0:22.60 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+p
		


* После расхода всей свободной памяти из swap в топ по процессорному времени влез kswapd0 и сместил наш скрипт (отвечает за процесс swap) 

	МиБ Mem :   3924,0 total,     91,1 free,   3762,2 used,     70,8 buff/cache
	МиБ Swap:   1710,0 total,      0,0 free,   1710,0 used.     27,1 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	     91 root      20   0       0      0      0 R  88,9   0,0 142:52.33 kswapd0
	   5477 root      20   0 4202232   3,0g    608 R  44,4  79,0   4:44.92 bash
	    468 systemd+  20   0   14956    624      0 D   5,6   0,0   0:26.38 systemd+
	   1652 maxd      20   0  162224    224      0 S   5,6   0,0   0:19.36 VBoxCli+
	      1 root      20   0  166748   3236      0 S   0,0   0,1   0:22.61 systemd

	
	    
* Последние данные из топ с нашим скриптом. После этого он был убит.

	top - 00:42:02 up  2:31,  2 users,  load average: 6,64, 2,36, 1,06
	Tasks: 208 total,   4 running, 204 sleeping,   0 stopped,   0 zombie
	%Cpu(s): 10,0 us, 66,7 sy,  0,0 ni,  3,3 id, 10,0 wa,  0,0 hi, 10,0 si,  0,0 st
	МиБ Mem :   3924,0 total,    956,1 free,   2819,3 used,    148,6 buff/cache
	МиБ Swap:   1710,0 total,   1020,6 free,    689,4 used.    890,9 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   7534 root      20   0       0      0      0 R  53,3   0,0   4:38.41 bash
	   1339 maxd      20   0  309064   2096   1128 S  20,0   0,1   0:00.40 snapd-desktop-i
	     91 root      20   0       0      0      0 S  13,3   0,0   5:20.25 kswapd0
	   1262 maxd      20   0 4854388 294420  55500 R  13,3   7,3   7:38.38 gnome-shell
	   1501 maxd      20   0  393064   1472   1108 S  13,3   0,0   0:00.02 gsd-rfkill
	   
### Второй этап

*Файл spy2.report содержит подробные изменения отслеживаемых строк в top за каждую секунду* 

*В ходе эксперимента было выяснено, что размер второго массива совпадает с размером из первого скрипта, а вот размер первого в 2 раза меньше второго*
	  
#### Размер массива перед падением

* arr1_size=**27000000** *для mem.bash*

* arr2_size=**54000000** *для mem2.bash*

#### Последние записи в системном журнале	  
	  
	[ 4259.693623] oom-kill:
	constraint=CONSTRAINT_NONE,
	nodemask=(null),
	cpuset=/,
	mems_allowed=0,
	global_oom,
	task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.Terminal.slice/vte-spawn-99255371-09cb-41dc-8d3b-160560333b40.scope,
	task=bash,
	pid=7650,
	uid=0
	
	[ 4259.693638] Out of memory: Killed process 7650 (bash) 
	total-vm:4268496kB,
	anon-rss:3110084kB,
	file-rss:0kB, 
	shmem-rss:0kB, 
	UID:0 
	pgtables:8376kB 
	oom_score_adj:0
	
#### Наблюдение за топ.

* Со старта оба скрипта равномерно поедали память и находились в топе по нагрузке процессора

	МиБ Mem :   3924,0 total,    911,0 free,   1780,3 used,   1232,7 buff/cache
	МиБ Swap:   1710,0 total,   1649,3 free,     60,7 used.   1747,8 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   7649 root      20   0  370536 355488   3304 R 100,0   8,8   0:22.44 bash
	   7650 root      20   0  363804 348600   3288 R  93,3   8,7   0:22.38 bash
	      1 root      20   0  166756   8064   5192 S   0,0   0,2   0:01.75 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp

* Как из в случае с первым экспериментом как только в физической памяти осталось 100 МиБ, скрипты начинали использовать раздел подкачки

	МиБ Mem :   3924,0 total,    115,3 free,   3375,4 used,    433,3 buff/cache
	МиБ Swap:   1710,0 total,   1614,2 free,     95,8 used.    183,2 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   7650 root      20   0 1184844   1,1g   1564 R 100,0  29,1   1:16.57 bash
	   7649 root      20   0 1195932   1,1g   1932 R 100,0  29,3   1:16.15 bash
	      1 root      20   0  166756   4884   2012 S   0,0   0,1   0:01.75 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp

* Когда закончилась память в разделе подкачки, повторилась ситуация с kswapd0

	МиБ Mem :   3924,0 total,    101,7 free,   3684,3 used,    138,1 buff/cache
	МиБ Swap:   1710,0 total,      0,0 free,   1710,0 used.      6,9 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	     91 root      20   0       0      0      0 R  88,2   0,0   3:20.89 kswapd0
	   7649 root      20   0 2153196   1,4g    368 R  58,8  36,4   2:19.66 bash
	   7650 root      20   0 2128644   1,4g    392 R  35,3  36,0   2:19.91 bash
	   6332 maxd      20   0  964196  26876  11032 D   5,9   0,7   0:03.76 nautilus
	   8024 root      20   0   21792   1600    844 R   5,9   0,0   0:00.01 top
	   
* С этого момента начались отличия: был убит только первый скрипт. Второй же продолжил жить, а память в обоих разделах немного освободилась

МиБ Mem :   3924,0 total,   1509,1 free,   2236,1 used,    178,9 buff/cache
МиБ Swap:   1710,0 total,    575,5 free,   1134,5 used.   1435,3 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
   7650 root      20   0 2144220   1,4g   1408 R 100,0  36,0   2:21.49 bash
      1 root      20   0  166756   4100   1224 S   0,0   0,1   0:01.77 systemd
      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+

* После этого память начала тратиться из раздела подкачки, пока не достигла ~100 МиБ, затем перешла на основной физический раздел. (пиды другие, так как я утерял данные из предыдущего репорта и запустил экперимент заново, но сути это не поменяло)

	МиБ Mem :   3924,0 total,   1716,3 free,   1980,6 used,    227,2 buff/cache
	МиБ Swap:   1710,0 total,    108,2 free,   1601,8 used.   1686,9 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   9838 root      20   0 2104488   1,1g   1356 R  93,8  28,9   2:31.73 bash
	      1 root      20   0  166756   6952   4396 S   0,0   0,2   0:04.05 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+	 
	      
* Повторение ситуации из первого эксперимента

	МиБ Mem :   3924,0 total,    103,6 free,   3587,2 used,    233,2 buff/cache
	МиБ Swap:   1710,0 total,    109,2 free,   1600,8 used.     77,3 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   9838 root      20   0 3788148   2,7g   1588 R 100,0  70,8   4:23.34 bash
	      1 root      20   0  166756   7340   4732 S   0,0   0,2   0:04.05 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+	
	      
	      
	МиБ Mem :   3924,0 total,    115,0 free,   3604,2 used,    204,8 buff/cache
	МиБ Swap:   1710,0 total,     27,0 free,   1683,0 used.     74,4 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	   9838 root      20   0 3890448   2,7g   1588 R 100,0  71,4   4:30.33 bash
	      1 root      20   0  166756   7156   4556 S   0,0   0,2   0:04.05 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+   
	      
* Теперь и второй скрипт был убит. Данные его последнего прибывания в топ


	МиБ Mem :   3924,0 total,   1131,0 free,   2663,1 used,    130,0 buff/cache
	МиБ Swap:   1710,0 total,    996,6 free,    713,4 used.   1052,9 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	    669 root      20   0  948576   5240      0 S   5,7   0,1   0:32.92 snapd
	   9838 root      20   0       0      0      0 R   5,7   0,0   4:43.51 bash
	   6027 maxd      20   0   18004   1204      4 R   4,9   0,0   0:00.58 systemd
	   6504 maxd      20   0  996604   1796      0 S   3,3   0,0   0:25.85 snap-st+
	   6332 maxd      20   0  970928  38412  16168 S   1,6   1,0   0:17.40 nautilus
	   
### Выводы:

	   	      	                 	   
