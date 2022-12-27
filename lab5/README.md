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

* Size=**54000000**

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

В ходе эксперимента было выяснено, что размер второго массива совпадает с размером массива из первого этапа, а вот размер первого массива в 2 раза меньше второго
	  
#### Размер массива перед падением

* arr1_size=**26000000** *для mem.bash*

* arr2_size=**52000000** *для mem2.bash*

#### Последние записи в системном журнале

	//для первого скрипта

	[ 7937.559155] oom-kill:
	constraint=CONSTRAINT_NONE,
	nodemask=(null),
	cpuset=/,
	mems_allowed=0,
	global_oom,
	task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.Terminal.slice/vte-spawn-99255371-09cb-41dc-8d3b-160560333b40.scope,
	task=bash,pid=10710,
	uid=0
	
	[ 7937.559170] Out of memory: Killed process 10710 (bash)
	total-vm:2097492kB, 
	anon-rss:1574488kB, 
	file-rss:0kB, 
	shmem-rss:0kB, 
	UID:0 
	pgtables:4124kB 
	oom_score_adj:0
	  
	  
	//и для второго
	  
	[ 8145.412821] oom-kill:
	constraint=CONSTRAINT_NONE,
	nodemask=(null),
	cpuset=/,
	mems_allowed=0,
	global_oom,
	task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.Terminal.slice/vte-spawn-99255371-09cb-41dc-8d3b-160560333b40.scope,
	task=bash,
	pid=10711,
	uid=0
	
	[ 8145.412837] Out of memory: Killed process 10711 (bash)
	total-vm:4091484kB,
	anon-rss:3148492kB, 
	file-rss:0kB, 
	shmem-rss:0kB, 
	UID:0 
	pgtables:8032kB 
	oom_score_adj:0
	
#### Наблюдение за топ.

* Со старта оба скрипта равномерно поедали память и находились в топе по нагрузке процессора

	  МиБ Mem :   3924,0 total,   2918,3 free,    756,8 used,    249,0 buff/cache
	  МиБ Swap:   1710,0 total,   1019,4 free,    690,6 used.   2899,7 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	  10710 root      20   0   38160  23092   3284 R  86,7   0,6   0:01.28 bash
	  10711 root      20   0   37368  22032   3280 R  86,7   0,5   0:01.29 bash
	   6220 maxd      20   0 4774988 290276  90000 S  26,7   7,2   7:50.73 gnome-s+
	   7270 maxd      20   0  942912 156172  30252 S   6,7   3,9   2:08.81 gedit
	      1 root      20   0  166756   5284   2684 S   0,0   0,1   0:04.11 systemd

* Как из в случае с первым экспериментом как только в физической памяти осталось 100 МиБ, скрипты начинали использовать раздел подкачки

	  МиБ Mem :   3924,0 total,    114,3 free,   3581,4 used,    228,3 buff/cache
	  МиБ Swap:   1710,0 total,    995,2 free,    714,8 used.     83,4 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	  10711 root      20   0 1492140   1,4g   3220 R  57,1  36,8   1:42.37 bash
	  10710 root      20   0 1508376   1,4g   3224 R  38,1  37,2   1:42.57 bash
	   6220 maxd      20   0 4795152 319532 109780 S  28,6   8,0   8:02.68 gnome-s+
	     91 root      20   0       0      0      0 S   9,5   0,0   5:21.23 kswapd0
	    103 root       0 -20       0      0      0 I   9,5   0,0   0:03.23 kworker+

* Когда закончилась память в разделе подкачки, повторилась ситуация с kswapd0

	  МиБ Mem :   3924,0 total,    107,8 free,   3727,1 used,     89,1 buff/cache
	  МиБ Swap:   1710,0 total,      0,0 free,   1710,0 used.     11,8 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	     91 root      20   0       0      0      0 R  76,5   0,0   5:25.58 kswapd0
	  10710 root      20   0 2083236   1,5g    400 R  58,8  38,8   2:24.27 bash
	  10711 root      20   0 2069376   1,5g    376 R  47,1  39,2   2:24.92 bash
	    414 systemd+  20   0   14988    228      0 S   5,9   0,0   0:43.52 systemd+
	      1 root      20   0  166756   2540      0 S   0,0   0,1   0:04.11 systemd
	   
* С этого момента начались отличия: был убит только первый скрипт. Второй же продолжил жить, а память в обоих разделах немного освободилась

	  МиБ Mem :   3924,0 total,   1644,2 free,   2139,3 used,    140,5 buff/cache
	  МиБ Swap:   1710,0 total,    311,3 free,   1398,7 used.   1577,7 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	  10711 root      20   0 2095908   1,4g   1444 R 100,0  36,7   2:28.03 bash
	      1 root      20   0  166756   2516      0 S   0,0   0,1   0:04.12 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par++	 
	      
* Повторение ситуации из первого эксперимента

	  МиБ Mem :   3924,0 total,   1493,5 free,   2280,2 used,    150,3 buff/cache
	  МиБ Swap:   1710,0 total,    311,8 free,   1398,2 used.   1431,9 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	  10711 root      20   0 2254836   1,6g   1612 R 100,0  40,7   2:38.41 bash
	      1 root      20   0  166756   2516      0 S   0,0   0,1   0:04.12 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+	
	      
	___	      
	      
	  МиБ Mem :   3924,0 total,    104,2 free,   3638,3 used,    181,5 buff/cache
	  МиБ Swap:   1710,0 total,     69,5 free,   1640,5 used.     58,4 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	  10711 root      20   0 3895068   2,9g   1612 R 100,0  75,2   4:25.97 bash
	      1 root      20   0  166756   2476      0 S   0,0   0,1   0:04.12 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd
	      3 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_gp
	      4 root       0 -20       0      0      0 I   0,0   0,0   0:00.00 rcu_par+  
	      
	___
	  
	  МиБ Mem :   3924,0 total,     98,0 free,   3744,1 used,     81,9 buff/cache
	  МиБ Swap:   1710,0 total,      0,0 free,   1710,0 used.      2,3 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	     91 root      20   0       0      0      0 R  94,4   0,0   5:50.01 kswapd0
	  10711 root      20   0 4069176   3,0g    380 R  66,7  77,8   4:38.00 bash
	   6220 maxd      20   0 4787636 226120  43304 D   5,6   5,6   8:08.91 gnome-s+
	      1 root      20   0  166756   2460      0 S   0,0   0,1   0:04.12 systemd
	      2 root      20   0       0      0      0 S   0,0   0,0   0:00.00 kthreadd     
	      
* Теперь и второй скрипт был убит. Последние данные топа

	  МиБ Mem :   3924,0 total,     83,8 free,   3760,8 used,     79,5 buff/cache
	  МиБ Swap:   1710,0 total,      0,0 free,   1710,0 used.     19,6 avail Mem 

	    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	     91 root      20   0       0      0      0 R  16,9   0,0   6:30.54 kswapd0
	    669 root      20   0  948576   5428      0 S  10,9   0,1   1:00.05 snapd
	   6504 maxd      20   0  996604   2508      0 R   3,5   0,1   0:41.33 snap-st+
	   8436 root      20   0       0      0      0 I   2,0   0,0   0:13.51 kworker+
	  11160 root      20   0       0      0      0 I   2,0   0,0   0:01.32 kworker+
	   
### Выводы:

Как в первом, так и во втором этапе, когда заканчивается физическая память (остается около 100 МиБ), начинает загружаться раздел подкачки. Как только в нем заканчивается место, скрипт завершает работу. В ходе второго эксперемента выяснилось, что два скрипта параллельно и равномерно поедают память, а когда она заканчивается, первый скрипт завершает работу, часть памяти, занимаемой им освобождается и тратится на второй скрипт, пока он также не завершит работу. Отсюда и размер второго массива в два раза больше первого.       


## Эксперимент 2

Изначально процессов было всего 10, и каждый из них тратил не больше N  памяти, а N взято в 10 раз меньше аварийного значения, поэтому скрипты завершали корректно. Теперь, когда их 30, сумма поедаемой памяти по всем процессам может превышать допустимый объем памяти, поэтому некоторые завершились аварийно при недостатке памяти. Максимальноезначение N=**2700000** - ровно в 2 раза меньше начального N=5400000.


