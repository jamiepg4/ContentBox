﻿<cfoutput>
#html.startForm(name="forgeBoxInstall",action=prc.xehForgeBoxInstall)#
#html.hiddenField(name="installDir",value=rc.installDir)#
#html.hiddenField(name="returnURL",value=rc.returnURL)#
#html.hiddenField(name="downloadURL")#

<cfif prc.errors>
#getPlugin("MessageBox").renderit()#
<cfelse>
	<!--- Title --->
	<h2>
		#prc.entriesTitle# (#prc.entries.recordcount# record(s) found)
	</h2>
	
	<!--- Filter Bar --->
	<div class="contentBar">
		<div class="filterBar">
			<div>
				#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
				#html.textField(name="entryFilter",size="30",class="textfield")#
			</div>
		</div>
	</div>
	<!--- Entries --->
	<cfloop query="prc.entries">
	<div class="forgeBox-entrybox" id="entry_#prc.entries.entryID#">
		<!--- Ratings --->
		<div class="forgebox-rating">
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 1>checked="checked"</cfif> value="1" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 2>checked="checked"</cfif> value="2" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 3>checked="checked"</cfif> value="3" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 4>checked="checked"</cfif> value="4" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 5>checked="checked"</cfif> value="5" disabled="disabled"/>
		</div>
		<!--- Info --->
		<h3>#prc.entries.title# v#prc.entries.version#</h3>
		<p>#prc.entries.summary#</p>
		<!--- Description --->
		<cfif len(prc.entries.description)>
			<a href="javascript:openForgeboxModal('entry_description_#prc.entries.entryID#')">> Read Description</a>
			<div id="entry_description_#prc.entries.entryID#" class="forgebox-infobox" style="display:none">
				<h2>Description</h2>
				#prc.entries.description#
			</div><br />
		</cfif>
		<!--- Install Instructions --->
		<cfif len(prc.entries.installinstructions)>
			<a href="javascript:openForgeboxModal('entry_ii_#prc.entries.entryID#')">> Read Installation Instructions</a>
			<div id="entry_ii_#prc.entries.entryID#" class="forgebox-infobox" style="display:none">
				<h2>Installation Instructions</h2>
				#prc.entries.installinstructions#
			</div><br />
		</cfif>
		<!--- Changelog --->
		<cfif len(prc.entries.changelog)>
			<a href="javascript:openForgeboxModal('entry_cl_#prc.entries.entryID#')">> Read Changelog</a>
			<div id="entry_cl_#prc.entries.entryID#" class="forgebox-infobox" style="display:none">
				<h2>Changelog</h2>
				#prc.entries.changelog#
			</div><br />
		</cfif>
		<br/>
		<!--- Download & Install --->
		<div class="forgebox-download">
			<a href="javascript:installEntry('entry_#prc.entries.entryID#','#prc.entries.downloadURL#')"
			   onclick="return confirm('Really install it?')"
			   title="Install Entry"><img src="#prc.cbRoot#/includes/images/entry-link.png" alt="Download" border="0" /></a>
		</div>
		<!--- Info --->
		<p>
			#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=prc.entries.username,size="30")#
			<label class="inline">By: </label> <a title="Open Profile" href="http://www.coldbox.org/profiles/show/#prc.entries.username#" target="_blank">#prc.entries.username#</a> |
			<label class="inline">Updated: </label> #dateFormat(prc.entries.updatedate)# |
			<label class="inline">Downloads: </label> #prc.entries.downloads# |
			<label class="inline">Views: </label> #prc.entries.hits#<br />
		</p>
	</div>
	</cfloop>
	<cfif NOT prc.entries.recordcount>
		#getPlugin("MessageBox").renderMessage("warning","No Entries Found!")#
	</cfif>
	#html.endForm()#
</cfif>
</cfoutput>