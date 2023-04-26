/**
 * The main module handler
 */
component{

	property name="schedulerHelper" inject="SchedulerHelper@cbSchedulerViewer";

	/**
	 * Module EntryPoint
	 */
	function index( event, rc, prc ){
		event.setView('home/index');
	}


	/**
	 * index
	 */
	function tasks( event, rc, prc ){
		tasks = schedulerHelper.getAllTasks().map((task)=>{
			var stats = task.task.getStats();
			return {
				'name'				: task.name,
				'scheduler'			: task.task.getScheduler().getName(),
				'disabled'			: task.task.getDisabled(),
				'created'			: dateTimeFormat(stats.created, 'short'),
				'lastRun'			: dateTimeFormat(stats.lastRun, 'short'),
				'lastDuration'		: stats.lastExecutionTime,
				'period'			: '#task.task.getPeriod()# #task.task.getTimeUnit()#', 
				'nextRun'			: isStruct(task.future) ? task.future.getDelay():0,
				'totalRuns'			: stats.totalRuns,
				'totalSuccess'		: stats.totalSuccess,
				'totalFailures'		: stats.totalFailures
			}
		});

		event.renderData( type="JSON", data=tasks);
	}


	/**
	 * runTask
	 */
	function runTask( event, rc, prc ){
		var scheduler = getInstance(rc.scheduler);
		var task = scheduler.getTaskRecord(rc.task).task;
		task.run();
		event.noRender();
	}


	/**
	 * toggleTask
	 */
	function toggleTask( event, rc, prc ){
		var scheduler = getInstance(rc.scheduler);
		var task = scheduler.getTaskRecord(rc.task).task;
		var disabled = task.getDisabled();
		disabled ? task.enable() : task.disable();
		event.noRender();
	}

}
