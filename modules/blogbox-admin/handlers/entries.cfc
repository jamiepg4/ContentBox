/**
* Manage blog entries
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="authorService"		inject="id:authorService@bb";

	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// exit Handlers
		rc.xehEntries 		= "#prc.bbEntryPoint#.entries";
		rc.xehEntryEditor 	= "#prc.bbEntryPoint#.entries.editor";
		rc.xehEntryRemove 	= "#prc.bbEntryPoint#.entries.remove";
		// Tab control
		prc.tabEntries = true;
	}
	
	// index
	function index(event,rc,prc){
		// paging
		event.paramValue("page",1);
		
		// prepare paging plugin
		rc.pagingPlugin = getMyPlugin(plugin="Paging",module="blogbox-admin");
		rc.paging 		= rc.pagingPlugin.getBoundaries();
		rc.pagingLink 	= event.buildLink('#rc.xehEntries#.page.@page@');
		
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category");
		// get all authors
		rc.authors    = authorService.getAll(sortOrder="lastName");
		
		// search entries?
		if( len(event.getValue("searchEntries","")) ){
			rc.entries = entryService.search( rc.searchEntries );
			rc.entriesCount = arrayLen(rc.entries);
		}
		else{
			// get all entries
			rc.entries 		= entryService.list(sortOrder="publishedDate desc",asQuery=false,offset=rc.paging.startRow-1,max=prc.bbSettings.bb_paging_maxrows);
			rc.entriesCount = entryService.count();
		}
		
		// exit handlers
		rc.xehEntrySearch = "#prc.bbEntryPoint#.entries";
		
		// view
		event.setView("entries/index");
	}

	// editor
	function editor(event,rc,prc){
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category");
		// get new or persisted
		rc.entry  = entryService.get( event.getValue("entryID",0) );
		// exit handlers
		rc.xehEntrySave = "#prc.bbEntryPoint#.entries.save";
		// view
		event.setView("entries/editor");
	}	

	// save
	function save(event,rc,prc){
		// params
		event.paramValue("allowComments",false);
		event.paramValue("slug","");
		
		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = getPlugin("HTMLHelper").slugify( rc.slug );
		
		// Create new categories?
		var categories = [];
		if( len(trim(rc.newCategories)) ){
			categories = categoryService.createCategories( trim(rc.newCategories) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		
		// get new entry and populate it
		var entry = populateModel( entryService.new() ).addPublishedtime(rc.publishedHour,rc.publishedMinute);
		// attach author
		entry.setAuthor( prc.oAuthor );
		// detach categories and re-attach
		entry.removeAllCategories();
		entry.setCategories( categories );
		
		// save entry
		entryService.save( entry );
		
		// relocate
		setNextEvent(rc.xehEntries);
	}
	
	// remove
	function remove(event,rc,prc){
		var oCategory	= categoryService.get( rc.categoryID );
    	
		if( isNull(oCategory) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Category detected!");
			setNextEvent( rc.xehCategories );
		}
		
		categoryService.delete( oCategory );
		getPlugin("MessageBox").setMessage("info","Category Removed!");
		setNextEvent(rc.xehCategories);
	}
	
	// pager viewlet
	function pager(event,rc,prc,authorID=0){
		// check if authorID exists in rc
		if( event.valueExists("pager_authorID") ){
			arguments.authorID = rc.pager_authorID;
		}
		// paging
		event.paramValue("page",1);
		// exit handlers
		rc.xehPager 		= "#prc.bbEntryPoint#.entries.pager";
		rc.xehEntryEditor	= "#prc.bbEntryPoint#.entries.editor";
		// prepare paging plugin
		rc.pager_pagingPlugin 	= getMyPlugin(plugin="Paging",module="blogbox-admin");
		rc.pager_paging 	  	= rc.pager_pagingPlugin.getBoundaries();
		rc.pager_pagingLink 	= "javascript:pagerLink(@page@)";
		// get author entries to page
		rc.pager_entries 		= entryService.findByAuthor(authorID=arguments.authorID,offset=rc.pager_paging.startRow-1,max=prc.bbSettings.bb_paging_maxrows);
		rc.pager_entriesCount 	= entryService.count(where="author.authorID = #arguments.authorID#");
		rc.pager_authorID		= arguments.authorID;
		// view pager
		return renderView(view="entries/pager",module="blogbox-admin");
	}
}
