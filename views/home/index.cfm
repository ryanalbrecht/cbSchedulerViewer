
<style>
	#task-root td, #task-root th {
		font-size: 12px !important;
	}

	.task-body .btn {
		padding: 1px 6px;
		font-size: 11px;
	}
</style>

<cfoutput>

<div id="task-root">
	<table class="table table-striped">
		<thead>
			<th>Name</th>
			<th>Scheduler</th>
			<th>Created</th>
			<th>Last Execution</th>
			<th>Last Duration</th>
			<th>Period</th>
			<th>Next Run</th>
			<th>Total Runs</th>
			<th>Total Success</th>
			<th>Total Failures</th>
			<th>Enabled</th>
			<th></th>
		</thead>
		<tbody class="task-body">
			<tr v-for="task in tasks">
				<td>{{ task.name }}</td>
				<td>{{ task.scheduler }}</td>
				<td>{{ task.created }}</td>
				<td>{{ task.lastRun }}</td>
				<td>{{ task.lastDuration }}</td>
				<td>{{ task.period }}</td>
				<td>{{ formatMs(task.nextRun) }}</td>
				<td>{{ task.totalRuns }}</td>
				<td>{{ task.totalSuccess }}</td>
				<td>{{ task.totalFailures }}</td>
				<td>
					<span v-if="!task.disabled" class="badge bg-success">Enabled</span>
					<span v-else class="badge bg-danger">Disabled</span>
				</td>
				<td class="text-end">
					<button class="btn btn-sm btn-secondary" @click="toggleTask(task)" style="width:50px">
						{{ task.disabled ? 'Enable' : 'Disable' }}
					</button>
					<button class="btn btn-sm btn-primary ms-2" @click='runTask(task)'>Run</button>
				</td>
			</tr>
		</tbody>
	</table>

	<div class="text-end">
		<button class="btn btn-sm" :class="[ shouldUpdate ? 'btn-secondary' : 'btn-dark' ]" @click="toggleUpdate" >
			{{ shouldUpdate ? 'Stop Update' : 'Start Update' }}
		</button>
	</div>
</div>


<script>

	var vm1 = Vue.createApp({
		data(){
			return {
				updateTimer: null,
				updateInterval: 1,
				shouldUpdate: true,
				serverEpoch: #dateDiff("s", "January 1 1970 00:00", now())#,
				tasks: []
			}
		},

		mounted(){
			this.doUpdate();
		},

		methods: {
			toggleUpdate(){
				this.shouldUpdate = !this.shouldUpdate;
				if(this.shouldUpdate){ this.doUpdate() }
			},

			scheduleUpdate(){
				clearTimeout(this.updateTimer);
				if(this.shouldUpdate){
					this.updateTimer = setTimeout( this.doUpdate, this.updateInterval * 1000 );
				}
			},

			async doUpdate(){
				clearTimeout(this.updateTimer);
				var resp = await fetch("/cbSchedulerViewer/home/tasks")
				var data = await  resp.json()
				this.tasks = data;
				this.scheduleUpdate();
			},

			formatMs(ms){
				var dur = luxon.Duration.fromMillis(ms)
				return dur.toFormat( "hh : mm : ss" );
			},

			async runTask(task){

				if(task.disabled){
					new Noty({
						type: 'warning',
						layout: 'topRight',
						timeout: 3000,
						text: `Task '${task.name}' will not run as it is disabled.`
					}).show();		
					return;			
				}

				var resp = await fetch(`/cbSchedulerViewer/home/runTask?task=${task.name}&scheduler=${task.scheduler}`)

				if( resp.ok ){
					this.doUpdate();
					new Noty({
						type: 'success',
						layout: 'topRight',
						timeout: 3000,
						text: `Task '${task.name}' ran successfully.`
					}).show();	
				} else {
					new Noty({
						type: 'error',
						layout: 'topRight',
						timeout: 3000,
						text: `There was an error when attempting to run task '${task.name}'.`
					}).show();
				}
			},

			async toggleTask(task){
				var resp = await fetch(`/cbSchedulerViewer/home/toggleTask?task=${task.name}&scheduler=${task.scheduler}`)
				if( resp.ok ){
					this.doUpdate();
				} else {
					new Noty({
						type: 'error',
						layout: 'topRight',
						timeout: 3000,
						text: `There was an error when attempting to toggle the task '${task.name}'.`
					}).show();
				}
			}

		}
	}).mount('##task-root');
</script>

</cfoutput>