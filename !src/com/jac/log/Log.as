﻿/*
Hook Logger Copyright 2010 Hook L.L.C.
For licensing questions contact hook: http://www.byhook.com

 This file is part of Hook Logger.

Hook Logger is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
at your option) any later version.

Hook Logger is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Hook Logger.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.jac.log
{//Package

	/**
	 * Helper class that allows for more convenient access to the logging system.
	 * This class should be used to access the Logger.  The Logger should not be accessed directly.
	 */
	public class Log
	{//Logger Class
	
		/**
		 * Logs a set of arguments out at the INFO debug level.  If the last argument is a string that starts with an @ sign, that log will be tagged.
		 * @param	...args a list of comma seperated parameters to log.  These parameters will each be converted to a string before being output.
		 * 
		 * @see com.jac.log.DebugLevel
		 * 
		 */
		static public function log(... args):void
		{//log
			var lc:Logger = Logger.getInstance();
			
			lc.log(DebugLevel.INFO, args);
			
		}//log
		
		/**
		 * Logs a set of arguments out at the WARNING debug level. If the last argument is a string that starts with an @ sign, that log will be tagged.
		 * @param	...args a list of comma seperated parameters to log.  These parameters will each be converted to a string before being output.
		 * 
		 * @see com.jac.log.DebugLevel
		 */
		static public function logWarning(...args):void
		{//log
			var lc:Logger = Logger.getInstance();
			lc.log(DebugLevel.WARNING, args);
		}//log
		
		/**
		 * Logs a set of arguments out at the ERROR debug level.  If the last parameter in the list is <code>true</code>, an exception will be thrown.
		 * Its worth noting that the exception will be thrown regardless of the VerboseLevel and DebugLevel filters.
		 * @param	...args a list of comma seperated parameters to log.  These parameters will each be converted to a string before being output.
		 * 
		 * @see com.jac.log.DebugLevel
		 * @see com.jac.log.VerboseLevel
		 */
		static public function logError(...args):void
		{//log
			var lc:Logger = Logger.getInstance();
			if (args[args.length - 1] == true)
			{//throw error
				args.pop();
				lc.log(DebugLevel.ERROR);
				throw Error(args);
			}//throw error
			else
			{//just log
				lc.log(DebugLevel.ERROR, args);
			}//just log
		}//log
		
		/**
		 * Logs out the current stack trace.
		 * @param	...args a list of comma seperated parameters to log before the stack trace.  These parameters will each be converted to a string before being output.
		 */
		static public function stackTrace(...args):void
		{//stackTrace
			var lc:Logger = Logger.getInstance();
			lc.stackTrace(args);
		}//stackTrace
		
		/**
		 * Replaces the current array of tags in the Logger.  This must be an Array of Strings that start with an @ sign.
		 * @param	logTagList
		 */
		static public function setTagFilterList(logTagList:Array):void
		{//setTagFilterList
			//check list
			for (var i:int = 0; i < logTagList.length; i++)
			{//check
				if ((logTagList[i] is String))
				{//bad list
					if (String(logTagList[i]).substring(0, 1) != "@")
					{//bad tag
						throw Error("Log::setTagFilterList: bad LogTag in passed in logTagList.  Must be string starting with an @ sign.");
					}//bad tag
				}//bad list
				else
				{//bad tag
					throw Error("Log::setTagFilterList: bad LogTag in passed in logTagList.  Must be string starting with an @ sign.");
				}//bad tag
			}//check
			
			var lc:Logger = Logger.getInstance();
			lc.tagFilterList = logTagList;
			
		}//setTagFilterList
		
		/**
		 * Adds a tag to the list of tags to show.  This must start with an @ sign.
		 * @param	logTag
		 */
		static public function addTag(logTag:String):void
		{//addTag
			var lc:Logger = Logger.getInstance();
			
			if (logTag.substring(0, 1) != "@")
			{//bad tag
				throw Error("Log::addTag: Tag must start with '@'");
			}//bad tag
			
			lc.tagFilterList.push(logTag);
		}//addTag
		
		/**
		 * Removes a tag from the tag list on the Logger.  This is ignored if the tag is not found in the list.
		 * @param	logTag
		 */
		static public function removeTag(logTag:String):void
		{//removeTag
		
			var lc:Logger = Logger.getInstance();
			
			for (var i:int = lc.tagFilterList.length-1; i >= 0; i--)
			{//find
				if (lc.tagFilterList[i] == logTag)
				{//remove
					lc.tagFilterList.splice(i, 1);
				}//remove
			}//find
		
		}//removeTag
		
		/**
		 * Sets the Log Level filter.  Anything included in the passed in filter will be shown.  Anything not included in the filter will not be shown.
		 * In order to show everything please pass in <code>DebugLevel.ALL</code>
		 * 
		 * @param	filter a bit mask including the debug levels that are to be output.
		 * 
		 * @see com.jac.log.DebugLevel
		 * 
		 * @example The following will set the Logger to show WARNINGS and ERRORS only.
		 * <listing version="3.0">
		 * 	Log.setLevelFilter(DebugLevel.WARNING | DebugLevel.ERROR);
		 * </listing>
		 */
		static public function setLevelFilter(filter:uint):void
		{//setLevelFilter
			var lc:Logger = Logger.getInstance();
			lc.levelFilter = filter;
		}//setLevelFilter
		
		/**
		 * Sets the Log Verbose filter.  This allows for some flexability in the amount of information displace for each output.  Using this filter
		 * you can choose to show or hide a number of bits of information about the time and location of the output.
		 * 
		 * <p> An example of ALL of the features turned on looks like this: </p>
		 * <code> [INFO] [0:00:14] [com.app.LogTesterMain::handleAddedToStage():45] This is an Info output </code>
		 * 
		 * <ul>
		 * <li>[INFO] - VerboseLevel.LEVEL option</li>
		 * <li>[0:00:14] - VerboseLevel.TIME - this is the time since the swf started.  Minutes:Seconds:Milliseconds</li>
		 * <li>[com.app.LogTesterMain::handleAddedToStage():45] - VerboseLevel.CLASSPATH.VerboseLevel.CLASS::VerboseLevel.FUNCTION():VerboseLevel.LINE 
		 * 														  <p>The line number will only be displayed if the "Permit Debugging" is turned on in the Publish Settings for the .fla</p>
		 * </li>
		 * <li>This is an Info output - this is the message passed into the Log call.</li>
		 * </ul>
		 * 
		 * @param	filter a bit mask including the VerboseLevels that are to be output.
		 * 
		 * @see #setLevelFilter()
		 */
		static public function setVerboseFilter(filter:uint):void
		{//setVerboseFilter
			var lc:Logger = Logger.getInstance();
			lc.verboseFilter = filter;
		}//setVerboseFilter
		
		/**
		 * Adds a target to send log output to.  Once an object is added it will then recieve output() calls from the Logger.
		 * 
		 * @param	logTarget an object that complies with the ILogTarget interface.
		 * 
		 * @return the passed in ILogTarget
		 * 
		 * @see com.jac.log.ILogTarget
		 */
		static public function addLogTarget(logTarget:ILogTarget):ILogTarget
		{//addLogTarget
			var lc:Logger = Logger.getInstance();
			
			lc.targetList.push(logTarget);
			
			return logTarget;
		}//addLogTarget
		
		/**
		 * Turns the Logger on and off.  If <code>false</code> is passed in logging is disabled.  Passing in <code>true</code> turns the logging back on.
		 * @param	isEnabled set to <code>true</code> to enable logging, and <code>false</code> to disable it.
		 */
		static public function enable(isEnabled:Boolean):void
		{//enable
			var lc:Logger = Logger.getInstance();
			lc.logEnabled = isEnabled;
		}//enable
		
		/**
		 * Shows or hides logs that do not have tags.
		 * @param	show set to <code>true</code> to show untagged logs, and <code>false</code> to hide them.
		 */
		static public function showUntagged(show:Boolean):void
		{//showUntagged
			var lc:Logger = Logger.getInstance();
			lc.showUntagged = show;
		}//showUntagged
	}//Logger Class

}//Package