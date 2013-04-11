﻿<cfoutput>
<div id="quickPost">
	<div id="quickPostContent">
		<!--- Entry Form  --->
		#html.startForm(action=prc.xehQPEntrySave,name="quickPostForm",novalidate="novalidate")#
			<h2>Quick Post</h2>
			<!--- Hidden Fields --->
			#html.hiddenField(name="contentID",value="")#
			#html.hiddenField(name="isPublished",value="true")#
			
			#html.startFieldset(legend='<i class="icon-edit icon-large"></i> Post')#
				<!--- title --->
				#html.textfield(name="title",maxlength="100",required="required",title="The title for this entry",class="textfield width98",
								value="Title Here", onclick="if( this.value == 'Title Here' ){ this.value = '';}")#
				<!--- content --->
				#html.textarea(name="quickcontent",required="required")#
			#html.endFieldSet()#
			
			<!--- Categories --->
			#html.startFieldset(legend='<i class="icon-tags icon-large"></i> Categories')#
				<cfloop from="1" to="#arrayLen(prc.qpCategories)#" index="x">
					#html.checkbox(name="category_#x#",value="#prc.qpCategories[x].getCategoryID()#")#
					#html.label(field="category_#x#",content="#prc.qpCategories[x].getCategory()#",class="inline")#
				</cfloop>
				<!--- New Categories --->
				#html.textField(name="newCategories",label="New Categories (Comma delimited)",size="45",title="Comma delimited list of new categories to create",class="textfield")#
			#html.endFieldSet()#
			<!--- Button Bar --->
			<div id="bottomCenteredBar" class="textRight">
				<button class="btn" onclick="return closeQuickPost()" title="Change your mind hugh?"> Cancel </button>
				&nbsp;<input type="submit" class="btn btn-primary" value="Save Draft" onclick="qpSaveDraft()" title="Not ready for primetime!">
				&nbsp;<input type="submit" class="btn btn-danger" value="Publish" title="Yeahaww! Let's Publish It!">
			</div>
		#html.endForm()#
	</div>
</div>
</cfoutput>