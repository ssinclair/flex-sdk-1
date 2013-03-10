////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.events
{

import flash.events.Event;
import mx.core.IToolTip;

/**
 *  The ToolTipEvent class represents ToolTip events, which are generated by the ToolTipManager 
 *  class. The ToolTipManager class calls the <code>dispatchEvent()</code> method
 *  of the object to which the tip applies to dispatch the event.
 *
 *  @see mx.managers.ToolTipManager
 *  @see mx.core.UIComponent
 */
public class ToolTipEvent extends Event
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>ToolTipEvent.TOOL_TIP_CREATE</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>toolTipCreate</code> event. 
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>tooltip</code></td><td>The ToolTip object to 
     *       which this event applies.</td></tr>
	 *  </table>
	 *
     *  @eventType toolTipCreate
	 */
	public static const TOOL_TIP_CREATE:String = "toolTipCreate";

	/**
	 *  The <code>ToolTipEvent.TOOL_TIP_END</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>toolTipEnd</code> event. 
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>tooltip</code></td><td>The ToolTip object to 
     *       which this event applies.</td></tr>
	 *  </table>
	 *
     *  @eventType toolTipEnd
	 */
	public static const TOOL_TIP_END:String = "toolTipEnd";

	/**
	 *  The <code>ToolTipEvent.TOOL_TIP_HIDE</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>toolTipHide</code> event. 
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>tooltip</code></td><td>The ToolTip object to 
     *       which this event applies.</td></tr>
	 *  </table>
	 *
     *  @eventType toolTipHide
	 */
	public static const TOOL_TIP_HIDE:String = "toolTipHide";

	/**
	 *  The <code>ToolTipEvent.TOOL_TIP_SHOW</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>toolTipShow</code> event. 
	 * 
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>tooltip</code></td><td>The ToolTip object to 
     *       which this event applies.</td></tr>
	 *  </table>
	 *
     *  @eventType toolTipShow
	 */
	public static const TOOL_TIP_SHOW:String = "toolTipShow";

	/**
	 *  The <code>ToolTipEvent.TOOL_TIP_SHOWN</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>toolTipShown</code> event. 
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>tooltip</code></td><td>The ToolTip object to 
     *       which this event applies.</td></tr>
	 *  </table>
	 *
     *  @eventType toolTipShown
	 */
	public static const TOOL_TIP_SHOWN:String = "toolTipShown";

	/**
	 *  The <code>ToolTipEvent.TOOL_TIP_START</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>toolTipStart</code> event. 
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>tooltip</code></td><td>The ToolTip object to 
     *       which this event applies.</td></tr>
	 *  </table>
	 *
     *  @eventType toolTipStart
	 */
	public static const TOOL_TIP_START:String = "toolTipStart";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble
	 *  up the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior
	 *  associated with the event can be prevented.
	 *
	 *  @param toolTip The ToolTip object to which this event applies.
	 */
	public function ToolTipEvent(type:String, bubbles:Boolean = false,
								 cancelable:Boolean = false,
								 toolTip:IToolTip = null)
	{
		super(type, bubbles, cancelable);

		this.toolTip = toolTip;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  toolTip
	//----------------------------------

	/**
	 *  The ToolTip object to which this event applies.
	 *  This object is normally an instance of ToolTip object,
	 *  but can be any UIComponent object.
	 */
	public var toolTip:IToolTip;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function clone():Event
	{
		return new ToolTipEvent(type, bubbles, cancelable, toolTip);
	}
}

}
