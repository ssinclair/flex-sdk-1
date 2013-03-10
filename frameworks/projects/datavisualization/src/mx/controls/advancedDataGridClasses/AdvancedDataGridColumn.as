////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2007 Adobe Systems Incorporated and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.controls.advancedDataGridClasses
{

import flash.display.DisplayObject;
import flash.events.Event;

import mx.controls.AdvancedDataGridBaseEx;
import mx.controls.TextInput;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.ClassFactory;
import mx.core.ContextualClassFactory;
import mx.core.EmbeddedFont;
import mx.core.EmbeddedFontRegistry;
import mx.core.IEmbeddedFontRegistry;
import mx.core.IFactory;
import mx.core.IFlexModuleFactory;
import mx.core.IIMESupport;
import mx.core.Singleton;
import mx.core.mx_internal;
import mx.formatters.Formatter;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.utils.StringUtil;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

include "../../styles/metadata/TextStyles.as";

/**
 *  The background color of the column.
 *  The default value is <code>undefined</code>, which means it uses the value of the 
 *  <code>backgroundColor</code> style of the associated AdvancedDataGrid control.
 *  The default value for the AdvancedDataGrid control is <code>0xFFFFFF</code>.
 */
[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

/**
 *  The name of a CSS style declaration for controlling other aspects of
 *  the appearance of the column headers.
 *  The default value is <code>undefined</code>, which means it uses the value of the 
 *  <code>headerStyleName</code> style of the associated AdvancedDataGrid control.
 *  The default value for the AdvancedDataGrid control is 
 *  <code>".advancedDataGridStyles"</code>.
 */
[Style(name="headerStyleName", type="String", inherit="no")]

/**
 *  The number of pixels between the container's left border and its content 
 *  area.
 *  There is no default value for this style.
 *  An item renderer's setting of the <code>paddingLeft</code> property 
 *  is used to determine the default.
 */
[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]

/**
 *  The number of pixels between the container's right border and its content 
 *  area.
 *  There is no default value for this style.
 *  An item renderer's setting of the <code>paddingRight</code> property 
 *  is used to determine the default.
 */
[Style(name="paddingRight", type="Number", format="Length", inherit="no")]

/**
 *  The AdvancedDataGridColumn class describes a column in an AdvancedDataGrid control.
 *  There is one AdvancedDataGridColumn per displayable column, even if a column
 *  is hidden or off-screen.
 *  The data provider items of an AdvancedDataGrid control 
 *  can contain properties that are not displayed,
 *  and therefore, do not need an AdvancedDataGridColumn.
 *  An AdvancedDataGridColumn allows specification of the color and font of the text
 *  in a column; specification of what kind of component displays the data for the column;
 *  specification of whether the column is editable, sortable, or resizeable;
 *  and specification of the text for the column header.
 *
 *  <p><strong>Notes:</strong><ul>
 *  <li>An AdvancedDataGridColumn only holds information about a column;
 *  it is not the parent of the item renderers in the column.</li>
 *  <li>If you specify an AdvancedDataGridColumn class without a <code>dataField</code>
 *  property, you must specify a <code>sortCompareFunction</code>
 *  property. Otherwise, sort operations may cause run-time errors.</li></ul> 
 *  </p>
 *
 *  @mxml
 *
 *  <p>You use the <code>&lt;mx.AdvancedDataGridcolumn&gt;</code> tag to configure a column
 *  of a AdvancedDataGrid control.
 *  You specify the <code>&lt;mx.AdvancedDataGridcolumn&gt;</code> tag as a child
 *  of the <code>columns</code> property in MXML.
 *  The <code>&lt;mx.AdvancedDataGridcolumn&gt;</code> tag inherits all of the 
 *  tag attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:AdvancedDataGridColumn
 *  <b>Properties </b>
 *    dataField="<i>No default</i>"
 *    dataTipField="<i>No default</i>"
 *    dataTipFunction="<i>No default</i>"
 *    editable="true|false"
 *    editorDataField="text"
 *    editorHeightOffset="0"
 *    editorUsesEnterKey="false|true"
 *    editorWidthOffset="0"
 *    editorXOffset="0"
 *    editorYOffset="0"
 *    formatter="null"
 *    headerRenderer="AdvancedDataGridItemRenderer"
 *    headerText="<i>No default</i>"
 *    headerWordWrap="undefined"
 *    imeMode="null"
 *    itemEditor="TextInput"
 *    itemRenderer="AdvancedDataGridItemRenderer"
 *    labelFunction="<i>No default</i>"
 *    minWidth="20"
 *    rendererIsEditor="false|true"
 *    resizable="true|false"
 *    showDataTips="false|true"
 *    sortable="true|false"
 *    sortCompareFunction="<i>No default</i>"
 *    sortDescending="false|true"
 *    styleFunction="<i>No default</i>"
 *    visible="true|false"
 *    width="100"
 *    wordWrap="false|true"
 * 
 *  <b>Styles</b>
 *    backgroundColor="0xFFFFFF"
 *    color="<i>No default.</i>"
 *    disabledColor="0xAAB3B3"
 *    fontAntiAliasType="advanced"
 *    fontFamily="<i>No default</i>"
 *    fontGridFitType="pixel"
 *    fontSharpness="0"
 *    fontSize="<i>No default</i>"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    headerStyleName="<i>No default</i>"
 *    kerning="false|true"
 *    letterSpacing="0"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    textAlign="right|center|left"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.controls.AdvancedDataGrid
 *
 *  @see mx.styles.CSSStyleDeclaration
 */
public class AdvancedDataGridColumn extends CSSStyleDeclaration implements IIMESupport
{
    include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param columnName The name of the field in the data provider 
     *  associated with the column, and the text for the header cell of this 
     *  column.  This is equivalent to setting the <code>dataField</code>
     *  and <code>headerText</code> properties.
     */
    public function AdvancedDataGridColumn(columnName:String = null)
    {
        super();

        if (columnName)
        {
            dataField = columnName;
            headerText = columnName;
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    //----------------------------------
	//  embeddedFontRegistry
    //----------------------------------

	/**
	 *  @private
	 *  Storage for the embeddedFontRegistry property.
	 *  This gets initialized on first access,
	 *  not at static initialization time, in order to ensure
	 *  that the Singleton registry has already been initialized.
	 */
	private static var _embeddedFontRegistry:IEmbeddedFontRegistry;

	/**
 	 *  @private
     *  A reference to the embedded font registry.
	 *  Single registry in the system.
	 *  Used to look up the moduleFactory of a font.
 	*/
	private static function get embeddedFontRegistry():IEmbeddedFontRegistry
	{
		if (!_embeddedFontRegistry)
		{
			_embeddedFontRegistry = IEmbeddedFontRegistry(
				Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
		}

		return _embeddedFontRegistry;
	}

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  The AdvancedDataGrid that owns this column.
     */
    mx_internal var owner:AdvancedDataGridBaseEx;

    /**
     *  @private
     */
    mx_internal var explicitWidth:Number;

    /**
     *  @private
     * Holds the last recorded value of the module factory used to create the font.
     */
    private var oldEmbeddedFontContext:IFlexModuleFactory = null;

    /**
     *  @private
     * 
     *  true if font properties do not need to be set.
     */
    private var fontPropertiesSet:Boolean = false;
    
 	/**
	 *  @private
	 * True if createInFontContext has been called.
	 */
	private var hasFontContextBeenSaved:Boolean = false;
	 
  	/**
	 * @private
	 * 
	 * Cache last value of embedded font.
	 */
  	private var cachedEmbeddedFont:EmbeddedFont = null;
  	 	 
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  sortDescending
    //----------------------------------

    /**
     *  Indicates whether the column sort is
     *  in ascending order, <code>false</code>, 
     *  or descending order, <code>true</code>.
     *  
     *  @default false
     */
    public var sortDescending:Boolean = false;

    //----------------------------------
    //  itemRenderer
    //----------------------------------

    /**
     *  @private
     *  Storage for the itemRenderer property.
     */
    private var _itemRenderer:IFactory;

    [Bindable("itemRendererChanged")]
    [Inspectable(category="Other")]

    /**
     *  The class factory for item renderer instances that display the 
     *  data for each item in the column.
     *  You can specify a drop-in item renderer,
     *  an inline item renderer, or a custom item renderer component as the 
     *  value of this property.
     *
     *  <p>The default item renderer is the AdvancedDataGridItemRenderer class,
     *  which displays the item data as text. </p>
     *
     *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer
     */
    public function get itemRenderer():IFactory
    {
        return _itemRenderer;
    }

    /**
     *  @private
     */
    public function set itemRenderer(value:IFactory):void
    {
        _itemRenderer = value;

        // this is expensive... but unless set after init (not recommended), ok.
        if (owner)
        {
            owner.invalidateList();
            owner.columnRendererChanged(this);
        }

        dispatchEvent(new Event("itemRendererChanged"));
    }

    //----------------------------------
    //  colNum
    //----------------------------------

    /**
     *  @private
     *  The zero-based index of this column as it is displayed in the grid.
     *  It is not related to the structure of the data being displayed.
     *  In MXML, the default order of the columns is the order of the
     *  <code>mx:AdvancedDataGridColumn</code> tags.
     */
    mx_internal var colNum:Number;

    //----------------------------------
    //  dataField
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the dataField property.
     */
    private var _dataField:String;

    [Bindable("dataFieldChanged")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  The name of the field or property in the data provider item associated 
     *  with the column. 
     *  Each AdvancedDataGridColumn control
     *  requires this property and/or the <code>labelFunction</code> property 
     *  to be set in order to calculate the displayable text for the item
     *  renderer.
     *  If the <code>dataField</code>
     *  and <code>labelFunction</code> properties are set, 
     *  the data is displayed using the <code>labelFunction</code> and sorted
     *  using the <code>dataField</code>.  If the property named in the
     *  <code>dataField</code> does not exist, the 
     *  <code>sortCompareFunction</code> must be set for the sort to work
     *  correctly.
     *
     *  <p>This value of this property is not necessarily the String that 
     *  is displayed in the column header.  This property is
     *  used only to access the data in the data provider. 
     *  For more information, see the <code>headerText</code> property.</p>
     *
     *  @see #headerText 
     */
    public function get dataField():String
    {
        return _dataField;
    }

    /**
     *  @private
     */
    public function set dataField(value:String):void
    {
        _dataField = value;

        if (owner)
        {
            owner.invalidateList();
        }

        dispatchEvent(new Event("dataFieldChanged"));
    }

    //----------------------------------
    //  dataTipField
    //----------------------------------

    /**
     *  @private
     *  Storage for the dataTipField property.
     */
    private var _dataTipField:String;

    [Bindable("dataTipFieldChanged")]
    [Inspectable(category="Advanced", defaultValue="label")]

    /**
     *  The name of the field in the data provider to display as the data tip. 
     *  By default, the AdvancedDataGrid control looks for a property named 
     *  <code>label</code> on each data provider item and displays it.
     *  However, if the data provider does not contain a <code>label</code>
     *  property, you can set the <code>dataTipField</code> property to
     *  specify a different property.  
     *  For example, you could set the value to "FullName" when a user views a
     *  set of people's names included from a database.
     */
    public function get dataTipField():String
    {
        return _dataTipField;
    }

    /**
     *  @private
     */
    public function set dataTipField(value:String):void
    {
        _dataTipField = value;

        if (owner)
        {
            owner.invalidateList();
        }

        dispatchEvent(new Event("dataTipChanged"));
    }

    //----------------------------------
    //  dataTipFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the dataTipFunction property.
     */
    private var _dataTipFunction:Function;

    [Bindable("dataTipFunctionChanged")]
    [Inspectable(category="Advanced")]

    /**
     *  Specifies a callback function to run on each item of the data provider 
     *  to determine its data tip.
     *  This property is used by the <code>itemToDataTip()</code> method.
     * 
     *  <p>By default, the control looks for a property named <code>label</code>
     *  on each data provider item and displays it as its dataTip.
     *  However, some data providers do not have a <code>label</code> property 
     *  or another property that you can use for displaying data 
     *  in the rows.
     *  For example, you might have a data provider that contains a lastName 
     *  and firstName fields, but you want to display full names as the dataTip.
     *  You can specify a function to the <code>dataTipFunction</code> property 
     *  that returns a single String containing the value of both fields. You 
     *  can also use the <code>dataTipFunction</code> property for handling 
     *  formatting and localization.</p>
     * 
     *  <p>The function must take a single Object parameter, containing the
     *  data provider element, and return a String.</p>
     */
    public function get dataTipFunction():Function
    {
        return _dataTipFunction;
    }

    /**
     *  @private
     */
    public function set dataTipFunction(value:Function):void
    {
        _dataTipFunction = value;

        if (owner)
        {
            owner.invalidateList();
        }

        dispatchEvent(new Event("labelFunctionChanged"));
    }

    //----------------------------------
    //  editable
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  A flag that indicates whether the items in the column are editable.
     *  If <code>true</code>, and the AdvancedDataGrid's <code>editable</code>
     *  property is also <code>true</code>, the items in a column are 
     *  editable and can be individually edited
     *  by clicking an item or by navigating to the item with the 
     *  Tab and Arrow keys.
     *
     *  @default true
     */
    public var editable:Boolean = true;

    //----------------------------------
    //  itemEditor
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  A class factory for the instances of the item editor to use for the 
     *  column, when it is editable.
     *
     *  <p>The default value is the mx.controls.TextInput control.</p>
     *
     *  @see mx.controls.TextInput
     */
    public var itemEditor:IFactory = new ClassFactory(TextInput);

    //----------------------------------
    //  editorDataField
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  The name of the property of the item editor that contains the new
     *  data for the list item.
     *  For example, the default <code>itemEditor</code> is
     *  TextInput, so the default value of the <code>editorDataField</code> 
     *  property is <code>"text"</code>, which specifies the 
     *  <code>text</code> property of the TextInput control.
     *
     *  @default "text"
     */
    public var editorDataField:String = "text";

    //----------------------------------
    //  editorHeightOffset
    //----------------------------------

    [Inspectable(category="General", defaultValue="0")]

    /**
     *  The height of the item editor, in pixels, relative to the size of the 
     *  item renderer.  This property can be used to make the editor overlap
     *  the item renderer by a few pixels to compensate for a border around the
     *  editor.  
     *  Note that changing these values while the editor is displayed
     *  will have no effect on the current editor, but will affect the next
     *  item renderer that opens an editor.
     *
     *  @default 0
     */
    public var editorHeightOffset:Number = 0;

    //----------------------------------
    //  editorWidthOffset
    //----------------------------------

    [Inspectable(category="General", defaultValue="0")]

    /**
     *  The width of the item editor, in pixels, relative to the size of the 
     *  item renderer.  This property can be used to make the editor overlap
     *  the item renderer by a few pixels to compensate for a border around the
     *  editor.
     *  Note that changing these values while the editor is displayed
     *  will have no effect on the current editor, but will affect the next
     *  item renderer that opens an editor.
     *
     *  @default 0
     */
    public var editorWidthOffset:Number = 0;

    //----------------------------------
    //  editorXOffset
    //----------------------------------

    [Inspectable(category="General", defaultValue="0")]

    /**
     *  The x location of the upper-left corner of the item editor,
     *  in pixels, relative to the upper-left corner of the item.
     *  This property can be used to make the editor overlap
     *  the item renderer by a few pixels to compensate for a border around the
     *  editor.
     *  Note that changing these values while the editor is displayed
     *  will have no effect on the current editor, but will affect the next
     *  item renderer that opens an editor.
     * 
     *  @default 0
     */
    public var editorXOffset:Number = 0;

    //----------------------------------
    //  editorYOffset
    //----------------------------------

    [Inspectable(category="General", defaultValue="0")]

    /**
     *  The y location of the upper-left corner of the item editor,
     *  in pixels, relative to the upper-left corner of the item.
     *  This property can be used to make the editor overlap
     *  the item renderer by a few pixels to compensate for a border around the
     *  editor.
     *  Note that changing these values while the editor is displayed
     *  will have no effect on the current editor, but will affect the next
     *  item renderer that opens an editor.
     *
     *  @default 0
     */
    public var editorYOffset:Number = 0;

    //----------------------------------
    //  editorUsesEnterKey
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]

    /**
     *  A flag that indicates whether the item editor uses Enter key.
     *  If <code>true</code> the item editor uses the Enter key and the
     *  AdvancedDataGrid will not look for the Enter key and move the editor in
     *  response.
     *  Note that changing this value while the editor is displayed
     *  will have no effect on the current editor, but will affect the next
     *  item renderer that opens an editor.
     *
     *  @default false
     */
    public var editorUsesEnterKey:Boolean = false;

    //----------------------------------
    //  headerRenderer
    //----------------------------------

    /**
     *  @private
     *  Storage for the headerRenderer property.
     */
    private var _headerRenderer:IFactory;

    [Bindable("headerRendererChanged")]
    [Inspectable(category="Other")]

    /**
     *  The class factory for item renderer instances that display the 
     *  column header for the column.
     *  You can specify a drop-in item renderer,
     *  an inline item renderer, or a custom item renderer component as the 
     *  value of this property.
     *
     *  <p>The default item renderer is the AdvancedDataGridItemRenderer class,
     *  which displays the item data as text. </p>
     */
    public function get headerRenderer():IFactory
    {
        return _headerRenderer;
    }

    /**
     *  @private
     */
    public function set headerRenderer(value:IFactory):void
    {
        _headerRenderer = value;

        // rebuild the headers
        if (owner)
        {
            owner.invalidateList();
            owner.columnRendererChanged(this);
        }

        dispatchEvent(new Event("headerRendererChanged"));
    }

    //----------------------------------
    //  headerText
    //----------------------------------

    /**
     *  @private
     *  Storage for the headerText property.
     */
    private var _headerText:String;

    [Bindable("headerTextChanged")]
    [Inspectable(category="General")]

    /**
     *  Text for the header of this column. By default, the AdvancedDataGrid
     *  control uses the value of the <code>dataField</code> property 
     *  as the header text.
     */
    public function get headerText():String
    {
        return (_headerText != null) ? _headerText : dataField;
    }

    /**
     *  @private
     */
    public function set headerText(value:String):void
    {
        _headerText = value;

        if (owner)
            owner.invalidateList();

        dispatchEvent(new Event("headerTextChanged"));
    }

    //----------------------------------
    //  headerWordWrap
    //----------------------------------

    /**
     *  @private
     *  Storage for the headerWordWrap property.
     */
    private var _headerWordWrap:*;

    [Inspectable(category="Advanced")]

    /**
     *  Set to <code>true</code> to wrap the text in the column header 
     *  if it does not fit on one line.
     *  If <code>undefined</code>, the AdvancedDataGrid control's <code>wordWrap</code> property 
     *  is used. 
     *  This property overrides the <code>headerWordWrap</code> property of 
     *  the AdvancedDataGrid control.
     *
     *  @default undefined
     */
    public function get headerWordWrap():*
    {
        return _headerWordWrap;
    }

    /**
     *  @private
     */
    public function set headerWordWrap(value:*):void
    {
        _headerWordWrap = value;

        if (owner)
        {
            owner.invalidateList();
        }
    }

    //----------------------------------
    //  imeMode
    //----------------------------------

    /**
     *  @private
     *  Storage for the imeMode property.
     */
    private var _imeMode:String;

    [Inspectable(category="Other")]

    /**
     *  Specifies the IME (input method editor) mode. 
     *  The IME mode enables users to enter text in Chinese, Japanese, and Korean.  
     *  Flex sets the IME mode when the <code>itemFocusIn</code> event occurs, 
     *  and sets it back
     *  to the previous value when the <code>itemFocusOut</code> event occurs. 
     *  The flash.system.IMEConversionMode class defines constants for 
     *  the valid values for this property.  
     *
     *  <p>The default value is null, in which case it uses the value of the 
     *  AdvancedDataGrid control's <code>imeMode</code> property.</p>
     *
     *  @see flash.system.IMEConversionMode
     */
    public function get imeMode():String
    {
        return _imeMode;
    }

    /**
     *  @private
     */
    public function set imeMode(value:String):void
    {
        _imeMode = value;
    }

    //----------------------------------
    //  rendererIsEditor
    //----------------------------------

    [Inspectable(category="General", defaultValue="false")]

    /**
     *  A flag that indicates that the item renderer is also an item editor.
     *  If this property is <code>true</code>, Flex
     *  ignores the <code>itemEditor</code> property and uses the item
     *  renderer for that item as the editor.
     *
     *  @default false
     */
    public var rendererIsEditor:Boolean = false;

    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function;

    [Bindable("labelFunctionChanged")]
    [Inspectable(category="Other")]

    /**
     *  A function that determines the text to display in this column.  By default,
     *  the column displays the text for the field in the data that matches the
     *  column name.  However, sometimes you want to display text based on
     *  more than one field in the data, or display something that does not
     *  have the format that you want.
     *  In such a case, you specify a callback function using <code>labelFunction</code>.
     *
     *  <p>For the AdvancedDataGrid control, the method signature has the following form:</p>
     *
     *  <pre>labelFunction(item:Object, column:AdvancedDataGridColumn):String</pre>
     *
     *  <p>where <code>item</code> contains the AdvancedDataGrid item object, and
     *  <code>column</code> specifies the AdvancedDataGrid column.</p>
     *
     *  <p>A callback function might concatenate the firstName and
     *  lastName fields in the data, or do some custom formatting on a Date,
     *  or convert a number for the month into the string for the month.</p>
     */
    public function get labelFunction():Function
    {
        return _labelFunction;
    }

    /**
     *  @private
     */
    public function set labelFunction(value:Function):void
    {
        _labelFunction = value;

        if (owner)
        {
            owner.invalidateList();
        }

        dispatchEvent(new Event("labelFunctionChanged"));
    }

    //----------------------------------
    //  minWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the minWidth property.
     */
    private var _minWidth:Number = 20;

    [Bindable("minWidthChanged")]
    [Inspectable(category="General", defaultValue="100")]

    /**
     *  The minimum width of the column, in pixels.
     *  @default 20
     */
    public function get minWidth():Number
    {
        return _minWidth;
    }

    /**
     *  @private
     */
    public function set minWidth(value:Number):void
    {
        _minWidth = value;

        if (owner)
        {
            owner.invalidateList();
        }

        if (_width < value)
            _width = value;

        dispatchEvent(new Event("minWidthChanged"));
    }

    //----------------------------------
    //  resizable
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  Set to <code>true</code> if the user is allowed to resize
     *  the width of the column.
     *  If <code>true</code>, the user can drag the grid lines between 
     *  the column headers to resize the column. 
     *
     *  @default true
     */
    public var resizable:Boolean = true;

    //----------------------------------
    //  showDataTips
    //----------------------------------

    /**
     *  @private
     *  Storage for the showDataTips property.
     */
    private var _showDataTips:*;

    [Inspectable(category="Advanced")]

    /**
     *  Set to <code>true</code> to show data tips in the column.
     *  If <code>true</code>, datatips are displayed for text in the rows. Datatips
     *  are tooltips designed to show the text that is too long for the row.
     *
     *  @default false
     */
    public function get showDataTips():*
    {
        return _showDataTips;
    }

    /**
     *  @private
     */
    public function set showDataTips(value:*):void
    {
        _showDataTips = value;

        if (owner)
        {
            owner.invalidateList();
        }
    }

    //----------------------------------
    //  sortable
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  Set to <code>true</code> to indicate that the user can click on the
     *  header of this column to sort the data provider.
     *  If this property and the AdvancedDataGrid <code>sortableColumns</code> property 
     *  are both <code>true</code>, the AdvancedDataGrid control dispatches a 
     *  <code>headerRelease</code> event when a user releases the mouse button 
     *  on this column's header. 
     *  If no other handler calls the <code>preventDefault()</code> method on
     *  the <code>headerRelease</code> event, the <code>dataField</code>
     *  property or <code>sortCompareFunction</code> in the column is used 
     *  to reorder the items in the data provider.
     * 
     *  @default true
     */
    public var sortable:Boolean = true;

    //----------------------------------
    //  sortCompareFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the sortCompareFunction property.
     */
    private var _sortCompareFunction:Function;

    [Bindable("sortCompareFunctionChanged")]
    [Inspectable(category="Advanced")]

    /**
     *
     *  A callback function that gets called when sorting the data in
     *  the column.  If this property is not specified, the sort tries
     *  to use a basic string or number sort on the data.
     *  If the data is not a string or number or if the <code>dataField</code>
     *  property is not a valid property of the data provider, the sort does
     *  not work or will generate an exception.
     *  If you specify a value of the <code>labelFunction</code> property,
     *  you must also provide a function to the <code>sortCompareFunction</code> property,
     *  unless sorting is not allowed on this column.
     *
     *  <p>The AdvancedDataGrid control uses this function to sort the elements of the data
     *  provider collection. The function signature of
     *  the callback function takes two parameters and has the following form:</p>
     *
     *  <pre>mySortCompareFunction(obj1:Object, obj2:Object):int </pre>
     *
     *  <p><code>obj1</code> &#x2014; A data element to compare.</p>
     * 
     *  <p><code>obj2</code> &#x2014; Another data element to compare with <code>obj1</code>.</p>
     * 
     *  <p>The function should return a value based on the comparison
     *  of the objects: </p>
     *  <ul>
     *    <li>-1 if obj1 should appear before obj2 in ascending order. </li>
     *    <li>0 if obj1 = obj2. </li>
     *    <li>1 if obj1 should appear after obj2 in ascending order.</li>
     *  </ul>
     * 
     *  <p><strong>Note:</strong> The <code>obj1</code> and
     *  <code>obj2</code> parameters are entire data provider elements and not
     *  just the data for the item.</p>
     *
     *  @default null
     */
    public function get sortCompareFunction():Function
    {
        return _sortCompareFunction;
    }

    /**
     *  @private
     */
    public function set sortCompareFunction(value:Function):void
    {
        _sortCompareFunction = value;

        dispatchEvent(new Event("sortCompareFunctionChanged"));
    }

    //----------------------------------
    //  visible
    //----------------------------------

    /**
     *  @private
     *  Storage for the visible property.
     */
    private var _visible:Boolean = true;

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  If <code>true</code>, the column is visible.
     *  Set to <code>false</code> to hide the column.
     *
     *  @default true
     */
    public function get visible():Boolean
    {
        return _visible;
    }

    /**
     *  @private
     */
    public function set visible(value:Boolean):void
    {
        if (_visible != value)
        {
            _visible = value;

            if (owner)
            {
                owner.columnsInvalid = true;
                
                owner.invalidateProperties();
                owner.invalidateSize();
                owner.invalidateList();
            }
        }
    }

    //----------------------------------
    //  width
    //----------------------------------

    /**
     *  @private
     *  Storage for the width property.
     */
    private var _width:Number = 100;

    // preferred width is the number we should use when measuring
    // regular width will be changed if we shrink columns to fit.
    mx_internal var preferredWidth:Number = 100;

    [Bindable("widthChanged")]
    [Inspectable(category="General", defaultValue="100")]

    /**
     *  The width of the column, in pixels. 
     *  If the AdvancedDataGrid's <code>horizontalScrollPolicy</code> property 
     *  is <code>false</code>, all visible columns must fit in the displayable 
     *  area, and the AdvancedDataGrid will not always honor the width of
     *  the columns if the total width of the columns is too
     *  small or too large for the displayable area.
     *
     *  @default 100
     */
    public function get width():Number
    {
        return _width;
    }

    /**
     *  @private
     */
    public function set width(value:Number):void
    {
        // remove any queued equal spacing commands
        explicitWidth = value;
        // use this value for future measurements
        preferredWidth = value;
        if (owner != null)
        {
            // if we aren't resizing as part of grid layout, resize it's column
            var oldVal:Boolean = resizable;
            // anchor this column to not accept any overflow width for accurate sizing
            resizable = false;
            owner.resizeColumn(colNum, value);
            resizable = oldVal;
        }
        else
        {
            // otherwise, just store the size
            _width = value;
        }
        dispatchEvent(new Event("widthChanged"));
    }

    /**
     *  @private
     *  Internal function to allow the AdvancedDataGrid to set the width of the
     *  column without locking it as an explicitWidth
     */
    mx_internal function setWidth(value:Number):void
    {
        _width = value;
    }

    //----------------------------------
    //  wordWrap
    //----------------------------------

    /**
     *  @private
     *  Storage for the wordWrap property.
     */
    private var _wordWrap:*;

    [Inspectable(category="Advanced")]

    /**
     *  Set to <code>false</code> to wrap the text in a row of this column
     *  because it does not fit on one line
     *  If <code>undefined</code>, the AdvancedDataGrid control's <code>wordWrap</code> property 
     *  is used.
     *
     *  @default undefined
     */
    public function get wordWrap():*
    {
        return _wordWrap;
    }

    /**
     *  @private
     */
    public function set wordWrap(value:*):void
    {
        _wordWrap = value;

        if (owner)
        {
            owner.invalidateList();
        }
    }

    //----------------------------------
    //  styleFunction
    //----------------------------------

    /**
     * @private
     */
     private var _styleFunction:Function;

    /**
     *  A callback function that is called when rendering each cell. 
     *  The signature of the function should be:
     *  
     *  <pre>function myStyleFunction(data:Object, column:AdvancedDataGridColumn):Object</pre>
     *
     *  <p><code>data</code> - data object associated with the item being rendered.</p>
     *  <p><code>column</code> - AdvancedDataGridColumn instance with 
     *  which the item renderer is associated.</p>
     *
     *  <p>The return value should be a object with styles as properties
     *   having the required values. 
     *   For example: </p>
     * 
     *  <pre>{ color:0xFF0000, fontWeight:"bold" }</pre>
     *
     */
     public function get styleFunction():Function
     {
            return _styleFunction;
     }

    /**
     * @private
     */
     public function set styleFunction(value:Function):void
     {
            _styleFunction = value;

            if (owner)
                owner.invalidateDisplayList();
     }


    //----------------------------------
    //  formatter
    //----------------------------------

    /**
     *  @private
     */
    private var _formatter:Formatter;

    /**
     *  An instance of a subclasses of mx.formatters.Formatter. 
     *  The control use this class to format the column text.
     *
     *  @default null
     */
    public function get formatter():Formatter
    {
            return _formatter;
    }

    /**
     *  @private
     */
    public function set formatter(value:Formatter):void
    {
            _formatter = value;

            if (owner)
                owner.invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override mx_internal function addStyleToProtoChain(
                                chain:Object, target:DisplayObject, filterMap:Object = null):Object
    {
        var parentGrid:AdvancedDataGridBaseEx = owner;
        var item:IListItemRenderer = IListItemRenderer(target);

        chain = super.addStyleToProtoChain(chain, target);
        
        // If the target data is a AdvancedDataGridColumn and has a data
        // field in its data, then it is a header so add the
        // AdvancedDataGrid.headerStyleName object to the head of the proto chain.
        if (item.data && (item.data is AdvancedDataGridColumn))
        {
            var s:Object;

            var headerStyleName:Object =
                parentGrid.getStyle("headerStyleName");
            if (headerStyleName)
            {
                if (headerStyleName is String)
                {
                    headerStyleName =
                        StyleManager.getStyleDeclaration("." + headerStyleName);
                }

                if (headerStyleName is CSSStyleDeclaration)
                    chain = headerStyleName.addStyleToProtoChain(chain, target);
            }

            headerStyleName = getStyle("headerStyleName");
            if (headerStyleName)
            {
                if (headerStyleName is String)
                {
                    headerStyleName =
                        StyleManager.getStyleDeclaration("." + headerStyleName);
                }

                if (headerStyleName is CSSStyleDeclaration)
                    chain = headerStyleName.addStyleToProtoChain(chain, target);
            }
        }
        
        // save the current font context
        if (!fontPropertiesSet)
        {
            fontPropertiesSet = true;
            saveFontContext(owner ? owner.moduleFactory : null);        
        }

        return chain;
    }

    /**
     *  @private
     */
    override public function setStyle(styleProp:String, value:*):void
    {
        fontPropertiesSet = false;
        
        var oldValue:Object = getStyle(styleProp);
        var regenerate:Boolean = false;

        // If this AdvancedDataGridColumn didn't previously have a factory, defaultFactory, or
        // overrides object, then this AdvancedDataGridColumn hasn't been added to the item
        // renderers proto chains.  In that case, we need to regenerate all the item
        // renderers proto chains.
        if (factory == null &&
            defaultFactory == null &&
            !overrides &&
            (oldValue !== value)) // must be !==
        {
            regenerate = true;
        }

        super.mx_internal::setStyle(styleProp, value);

        // The default implementation of setStyle won't always regenerate
        // the proto chain when headerStyleName is set, and we need to make sure
        // that they are regenerated
        if (styleProp == "headerStyleName")
        {
            if (owner)
            {
                owner.regenerateStyleCache(true);
                owner.notifyStyleChangeInChildren("headerStyleName", true);
            }
            return;
        }

        if (owner)
        {
            if (regenerate)
            {
                owner.regenerateStyleCache(true);
            }
            
            if (hasFontContextChanged(owner.moduleFactory))
            {
                owner.columnRendererChanged(this);
            }

            owner.invalidateList();            
        }

    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Apply column's Formatter if present.
     */
    private function applyFormatting(data:String):String
    {
        if (formatter != null && data != null)
        {
            var label:String = formatter.format(data);

            // Silently ignore formatter errors. For example, errors occur when
            // the property corresponding to the dataField is not present in the
            // row object i.e. it'll be empty and it's not anybody's fault that
            // it's an error.
            if (formatter.error)
                return null;

            return label;
        }
        else
        {
            return data;
        }
    }

    /**
     *  Returns the String that the item renderer displays for the given data object.
     *  If the AdvancedDataGridColumn or its AdvancedDataGrid control 
     *  has a non-null <code>labelFunction</code> 
     *  property, it applies the function to the data object. 
     *  Otherwise, the method extracts the contents of the field specified by the 
     *  <code>dataField</code> property, or gets the string value of the data object.
     *  If the method cannot convert the parameter to a String, it returns a
     *  single space.
     *
     *  @param data Object to be rendered.
     *
     *  @param withFormatting It <code>true</code> specifies to return 
     *  the String with any formatting applied to it.
     * 
     *  @return Displayable String based on the data.
     */
    public function itemToLabel(data:Object, withFormatting:Boolean=true):String
    {
        var label:String = itemToLabelWithoutFormatting(data);
        if (withFormatting)
            return applyFormatting(label);
        return label;
    }

    /**
     *  This is the original AdvancedDataGrid.itemToLabel() that has been wrapped with applyFormatting()
     */
    private function itemToLabelWithoutFormatting(data:Object):String
    {
        var headerInfo:AdvancedDataGridHeaderInfo  = owner.mx_internal::getHeaderInfo(this);
        //In case of Column grouping, when a column has a parent with dataField/labelFunction set, this column is
        //supposed to take value from what its parent supplies it
        if(headerInfo.internalLabelFunction!=null)
            data = headerInfo.internalLabelFunction(data, this);
   
        if (!data)
            return " ";

        if (labelFunction != null)
            return labelFunction(data, this);

        if (owner.labelFunction != null)
            return owner.labelFunction(data, this);

        if (typeof(data) == "object" || typeof(data) == "xml")
        {
            try
            {
                data = data[dataField];
            }
            catch(e:Error)
            {
                data = null;
            }
        }

        if (data is String)
            return String(data);

        try
        {
            return data.toString();
        }
        catch(e:Error)
        {
        }

        return " ";
    }

    /**
     *  Returns a String that the item renderer displays as the data tip for the given data object,
     *  based on the <code>dataTipField</code> and <code>dataTipFunction</code> properties.
     *  If the method cannot convert the parameter to a String, it returns a
     *  single space.
     * 
     *  <p>This method is for use by developers who are creating subclasses 
     *  of the AdvancedDataGridColumn class.
     *  It is not for use by application developers.</p>
     *
     *  @param data Object to be rendered.
     *
     *  @return Displayable String based on the data.
     */
    public function itemToDataTip(data:Object):String
    {
        if (dataTipFunction != null)
            return dataTipFunction(data);

        if (owner.dataTipFunction != null)
            return owner.dataTipFunction(data);

        // for header items, return the header text
        if (data is AdvancedDataGridColumn)
            return AdvancedDataGridColumn(data).headerText;
        
        if (typeof(data) == "object" || typeof(data) == "xml")
        {
            var field:String = dataTipField;
            if (!field)
                field = owner.dataTipField;
            try
            {
                if (data[field] != null)
                    data = data[field];
                else if (data[dataField] != null)
                    data = data[dataField];
            }
            catch(e:Error)
            {
                data = null;
            }                
        }

        if (data is String)
            return String(data);

        try
        {
            return data.toString();
        }
        catch(e:Error)
        {
        }

        return " ";
    }
    
    /**
	 * @private
	 * 
	 * Get the embedded font for a set of font attributes.
	 */ 
	mx_internal function getEmbeddedFont(fontName:String, bold:Boolean, italic:Boolean):EmbeddedFont
	{
		// Check if we can reuse a cached value.
		if (cachedEmbeddedFont)
		{
			if (cachedEmbeddedFont.fontName == fontName &&
			    cachedEmbeddedFont.fontStyle == EmbeddedFontRegistry.getFontStyle(bold, italic))
			{
				return cachedEmbeddedFont;
			}	
		}
		
		cachedEmbeddedFont = new EmbeddedFont(fontName, bold, italic);		
		
		return cachedEmbeddedFont;
	}
	
    /**
     * @private
     * 
     * Save the current font context to member fields.
     */
    private function saveFontContext(flexModuleFactory:IFlexModuleFactory):void
    {
        // Save for hasFontContextChanged()
        hasFontContextBeenSaved = true;
        var fontName:String = StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
        var fontWeight:String = getStyle("fontWeight");
        var fontStyle:String = getStyle("fontStyle");
        var bold:Boolean = fontWeight == "bold";
        var italic:Boolean = fontStyle == "italic";
        var embeddedFont:EmbeddedFont =
        	getEmbeddedFont(fontName, bold, italic);
        oldEmbeddedFontContext =
        	embeddedFontRegistry.getAssociatedModuleFactory(
        		embeddedFont, flexModuleFactory);
    }
    
    /**
     *  @private
     *  Test if the current font context has changed
	 *  since that last time saveFontContext() was called.
     */
    mx_internal function hasFontContextChanged(
							flexModuleFactory:IFlexModuleFactory):Boolean
    {
        
        // If the font has not been saved yet, then return false,
        // the font context has not changed.
        if (!hasFontContextBeenSaved)
            return false;

        var fontName:String =
        	StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
        var fontWeight:String = getStyle("fontWeight");
        var fontStyle:String = getStyle("fontStyle");
        
        // Check if the module factory has changed.
        var bold:Boolean = fontWeight == "bold";
        var italic:Boolean = fontStyle == "italic";
        var embeddedFont:EmbeddedFont =
        	getEmbeddedFont(fontName, bold, italic);
        var fontContext:IFlexModuleFactory =
        	embeddedFontRegistry.getAssociatedModuleFactory(
        		embeddedFont, flexModuleFactory)
        return fontContext != oldEmbeddedFontContext;
    }

    /**
     *  @private
     * 
     *  Sets the properties of this Object to the given column.
     * 
     *  It sets only the required properties.
     *
     *  @param col AdvancedDataGridColumn in which the properties are to be set.
     *
     */
    protected function copyProperties(col:AdvancedDataGridColumn):void
    {
        // copy properties
        col.defaultFactory = this.defaultFactory; 
        col.editable = this.editable;
        col.editorDataField = this.editorDataField;
        col.editorHeightOffset = this.editorHeightOffset;
        col.editorUsesEnterKey = this.editorUsesEnterKey;
        col.editorWidthOffset = this.editorWidthOffset;
        col.editorXOffset =  this.editorXOffset;
        col.editorYOffset = this.editorYOffset;
        col.factory = this.factory;
        col.itemEditor =  this.itemEditor;
        col.rendererIsEditor = this.rendererIsEditor;
        col.resizable = this.resizable;
        col.sortable = this.sortable;
        col.sortDescending = this.sortDescending;
        col.dataField = this.dataField;
        col.dataTipField = this.dataTipField;
        col.dataTipFunction = this.dataTipFunction;
        col.formatter = this.formatter;
        col.headerRenderer = this.headerRenderer;
        col.headerText = this.headerText;
        col.headerWordWrap = this.headerWordWrap;
        col.imeMode = this.imeMode;
        col.itemRenderer = this.itemRenderer;
        col.labelFunction = this.labelFunction;
        col.minWidth = this.minWidth;
        col.showDataTips = this.showDataTips;
        col.sortCompareFunction = this.sortCompareFunction;
        col.styleFunction = this.styleFunction;
        col.visible = this.visible;
        col.width = this.width;
        col.wordWrap = this.wordWrap;
        
        // copy styles
        col.public::setStyle("backgroundColor",this.getStyle("backgroundColor"));
        col.public::setStyle("headerStyleName",this.getStyle("headerStyleName"));
        col.public::setStyle("paddingLeft",this.getStyle("paddingLeft"));
        col.public::setStyle("paddingRight",this.getStyle("paddingRight"));
    }
    
    /**
     * 
     *  Clone this column and return a new Column with the 
     *  same properties and styles as this one.
     * 
     *  It does not set all the available properties
     *
     *  @return col AdvancedDataGridColumn.
     *
     */
    public function clone():AdvancedDataGridColumn
    {
        // make a new column
        var col:AdvancedDataGridColumn = new AdvancedDataGridColumn();
        
        // copy the properties
        copyProperties(col);
        
        return col;
    }
}

}
