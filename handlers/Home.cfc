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
				'module'			: task.module,
				'created'			: dateTimeFormat(stats.created, 'short'),
				'lastRun'			: dateTimeFormat(stats.lastRun, 'short'),
				'lastDuration'		: stats.lastExecutionTime,
				'period'			: '#task.task.getPeriod()# #task.task.getTimeUnit()#', 
				'nextRun'			: task.future.getDelay(),
				'totalRuns'			: stats.totalRuns,
				'totalSuccess'		: stats.totalSuccess,
				'totalFailures'		: stats.totalFailures
			}
		})
		
		return serializeJSON(tasks);
	}

}
