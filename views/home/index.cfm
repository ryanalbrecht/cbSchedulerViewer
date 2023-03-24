<cfoutput>

<div id="task-root">
	<table class="table table-striped">
		<thead>
			<th>Name</th>
			<th>Module</th>
			<th>Created</th>
			<th>Last Execution</th>
			<th>Last Duration</th>
			<th>Period</th>
			<th>Next Run</th>
			<th>Total Runs</th>
			<th>Total Success</th>
			<th>Total Failures</th>
		</thead>
		<tbody>
			<tr v-for="task in tasks">
				<td>{{ task.name }}</td>
				<td>{{ task.module }}</td>
				<td>{{ task.created }}</td>
				<td>{{ task.lastRun }}</td>
				<td>{{ task.lastDuration }}</td>
				<td>{{ task.period }}</td>
				<td>{{ formatMs(task.nextRun) }}</td>
				<td>{{ task.totalRuns }}</td>
				<td>{{ task.totalSuccess }}</td>
				<td>{{ task.totalFailures }}</td>
			</tr>
		</tbody>
	</table>

	<div class="text-end">
		<button class="btn btn-sm" :class="[ shouldUpdate ? 'btn-danger' : 'btn-success' ]" @click="toggleUpdate" >
			{{ shouldUpdate ? 'Stop Update' : 'Start Update' }}
		</button>
	</div>
</div>

<script>

	var vm1 = Vue.createApp({
		data(){
			return {
				updateTimer: null,
				updateInterval: 1.1,
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

			doUpdate(){
				fetch("/cbScheduler-viewer/home/tasks")
					.then( (response) => response.json() )
					.then( (data) => { 
						this.tasks = data
					});

				this.scheduleUpdate();
			},

			formatMs(ms){
				var dur = luxon.Duration.fromMillis(ms)
				return dur.toFormat( "hh : mm : ss" );
			}
		}
	}).mount('##task-root');
</script>

</cfoutput>