component {

	property name="wirebox" inject="wirebox";
	property name="moduleService" inject="coldbox:moduleService";

	function getAllTasks(){

		var settings = wirebox.getInstance( dsl = "coldbox:moduleSettings:cbSchedulerViewer" );
		var schedulers = settings.getSchedulers();

		var tasks = schedulers.reduce( (r,i) => { 
			return arrayMerge(r, getSchedulerTasks(i));
		}, []);

		//get module schedulers
		var loadedModules = moduleService.getLoadedModules();

		for( var module in loadedModules ){
			try{				
				var moduleScheduler = wirebox.getInstance('cbScheduler@#module#');
				var moduleTasks = getSchedulerTasks(moduleScheduler);
				tasks = arrayMerge(tasks, moduleTasks);
			}catch(any e){
				//do nothing, assume the module does not have a scheduler
			}
		}

		return tasks;
	}

	function getSchedulerTasks(required scheduler){
		var tasks = scheduler.getTasks().reduce((r,k,v)=>{ 
			r.append(v);
			return r;
		}, []);

		return tasks;
	}
}