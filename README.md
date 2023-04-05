

# # [](https://www.forgebox.io/view/cbSchedulerViewer#cbSchedulerViewer)cbSchedulerViewer
![alt text](https://github.com/ryanalbrecht/cbSchedulerViewer/blob/main/preview.gif?raw=true)

## Introduction

This is a module you can drop into your coldbox to get a nicely formatted overview of the tasks the were registered using the coldbox scheduler.

This module should be considered experimetal, so use at your own risk until further development has been done.

## Requirements

+ Adobe ColdFusion 2018+
+ Lucee 5+

## Installation

Installation is easy through [CommandBox](https://www.ortussolutions.com/products/commandbox) and [ForgeBox](https://www.coldbox.org/forgebox).  Simply type `box install cbSchedulerViewer` to get started.

## Usage

The module should be automatically registered and ready to use. Simply navigate to `/cbSchedulerViewer`

e.g. `http://127.0.0.1:8081/cbSchedulerViewer`

By default the module will retrieve tasks from all module schedulers as well as the default global scheduler (appScheduler@coldbox). This can be overriden by creating the following struct in `moduleSettings`  in your config.cfc. 

It will be your job to override the closure and return an array of schedulers.

```
// cbSchedulerViewer
cbSchedulerViewer = {
	getSchedulers = function(){
		var wirebox = controller.getWirebox();
		return [ 
			wirebox.getInstance('appScheduler@coldbox')
		];
	}
}
```