# Отчет по лабораторной работе 5

## Эксперимент 1

### Данные о текущей конфигурации операционной системы

* Общий объем оперативной памяти: **3924**
* Объем раздела подкачки **1710**
* Размер страницы виртуальной памяти: **4096**
* Объем свободной физической памяти в ненагруженной системе: ~**3000**
* Объем свободного пространства в разделе подкачки в ненагруженной системе: ~**950**

*Одна консоль*

### Размер массива перед падением

* Size=**56_000_000**

### Последние записи в системном журнале
	oom-kill:
	  constraint=CONSTRAINT_NONE,
	  nodemask=(null),
	  cpuset=/,
	  mems_allowed=0,
	  global_oom,
	  task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.Terminal.slice/vte-spawn-502978ee-1f15-4ad8-9a0d-e00bd89417a5.scope,
	  task=bash,
	  pid=6407,
	  uid=1000

	Out of memory: Killed process 6407 (bash) 
	  total-vm:4440624kB,
	  anon-rss:3154188kB,
  file-rss:0kB,
  shmem-rss:0kB,
  UID:1000 pgtables:8712kB oom_score_adj:0

