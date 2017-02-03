<?xml version="1.0"?>
<xslt:stylesheet xmlns:xslt="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xslt:template match="XMLConfigSettings">
    <html>
      <SCRIPT language='javascript'>function ToggleCode(id){el=document.all[id];if(el.style.display=="none"){el.style.display="";}else{el.style.display="none";}}</SCRIPT>
      <HEAD>
        <TITLE>
          <xslt:value-of select="FILEINFO/@type"/> (<xslt:value-of select="FILEINFO/@author"/>)
        </TITLE>
        <link href="./../styles.css" rel="stylesheet" type="text/css"/>
      </HEAD>
      <BODY>
        <xslt:apply-templates select="FILEINFO"/>
        <xslt:apply-templates select="SYNTAX"/>
      </BODY>
    </html>
  </xslt:template>

  <xslt:template match="FILEINFO">
    <h3>File information</h3>
    <table>
      <tr>
        <td class="TD-KEY">Author</td>
        <td>
          <xslt:value-of select="@author"/>
        </td>
      </tr>
      <tr>
        <td class="TD-KEY">Data type</td>
        <td>
          <xslt:value-of select="@type"/>
        </td>
      </tr>
    </table>
  </xslt:template>

  <xslt:template match="SYNTAX">
    <h3>
      Syntax definition for <xslt:value-of select="@id"/> <xslt:if test="@inherit">
        inherited from
        <a href="{normalize-space(@inherit_url)}">
          <xslt:value-of select="@inherit" />
        </a>
      </xslt:if>
    </h3>
    <xslt:apply-templates select="CodeTemplates"/>
    <xslt:apply-templates select="SPECIFICATION"/>
    <xslt:apply-templates select="SCOPES"/>
    <xslt:apply-templates select="FORMAT"/>
    <xslt:apply-templates select="SYNTAXINFO"/>
    <xslt:apply-templates select="STYLES"/>
  </xslt:template>

  <xslt:template match="CodeTemplates">
    <h4>
      User defined templates
    </h4>
    <table>
      <tr class="TR-HEADER">
        <td>Key</td>
        <td>Description</td>
        <td>Text</td>
      </tr>
      <xslt:for-each select="Template">
        <tr class="TR-NORMAL">
          <td class="TD-KEY">
            <xslt:value-of select="@key"/>
          </td>
          <td>
            <xslt:value-of select="@descr"/>
          </td>
          <td>
            <xslt:value-of select="."/>
          </td>
        </tr>
      </xslt:for-each>
    </table>
  </xslt:template>

  <xslt:template match="SPECIFICATION">
    <h3>Specification</h3>
    <table>
      <tr class="TR-HEADER">
        <td>Parameter</td>
        <td>Value</td>
      </tr>
      <xslt:if test="FilePattern">
        <tr class="TR-NORMAL">
          <td>Files Pattern</td>
          <td>
            <xslt:value-of select="FilePattern/@mask"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:for-each select="FilePattern/Pair">
        <tr class="TR-NORMAL">
          <td>
            Files Pair <xslt:value-of select="position()"/>
          </td>
          <td>
            <xslt:value-of select="@file1"/> -> <xslt:value-of select="@file2"/>
          </td>
        </tr>
      </xslt:for-each>
      <xslt:if test="LexerDll">
        <tr class="TR-NORMAL">
          <td>External Lexer Dll</td>
          <td>
            <xslt:value-of select="LexerDll"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:if test="CaseSensitive">
        <tr class="TR-NORMAL">
          <td>CaseSensitive</td>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="CaseSensitive"/>
          </xslt:call-template>
        </tr>
      </xslt:if>
      <xslt:if test="OpenClose">
        <tr class="TR-NORMAL">
          <td>OpenClose</td>
          <td>
            <xslt:value-of select="OpenClose"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:if test="Delimiters">
        <tr class="TR-NORMAL">
          <td>Delimiters</td>
          <td>
            <xslt:value-of select="Delimiters"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:if test="LineEnd">
        <tr class="TR-NORMAL">
          <td>LineEnd</td>
          <td>
            <xslt:value-of select="LineEnd"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:if test="MaxLineLength">
        <tr class="TR-NORMAL">
          <td>MaxLineLength</td>
          <td>
            <xslt:value-of select="MaxLineLength"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:if test="Operators">
        <tr class="TR-NORMAL">
          <td>Operators</td>
          <td>
            <xslt:value-of select="Operators"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:if test="Words">
        <tr class="TR-NORMAL">
          <td>Words</td>
          <td>
            <xslt:value-of select="Words"/>
          </td>
        </tr>
      </xslt:if>      
      <xslt:if test="WrapBy">
        <tr class="TR-NORMAL">
          <td>WrapBy</td>
          <td>
            <xslt:value-of select="WrapBy"/>
          </td>
        </tr>
      </xslt:if>      
      <xslt:if test="Numbers">
        <tr class="TR-NORMAL">
          <td>Numbers</td>
          <td>
            <xslt:value-of select="Numbers"/>
          </td>
        </tr>
      </xslt:if>
      <xslt:apply-templates select="HierarchySeparator"/>
    </table>
  </xslt:template>

  <xslt:template match="HierarchySeparator">
    <xslt:for-each select="Separator">
      <tr class="TR-NORMAL">
        <td>
          Hierarchy Separator <xslt:value-of select="@id"/>
        </td>
        <td>
          <xslt:value-of select="@text"/>
        </td>
      </tr>
    </xslt:for-each>
  </xslt:template>

  <xslt:template match="SCOPES">
    <h3>Structures</h3>
    <table>
      <tr class="TR-HEADER">
        <td>Open</td>
        <td>Middle</td>
        <td>Close</td>
        <td>Has Name</td>
        <td>At Sentence Start</td>
        <td>Has Header</td>        
        <td>Has Separator</td>
        <td>Strict Usage</td>        
      </tr>
      <xslt:for-each select="Scope">
        <tr class="TR-NORMAL">
          <td>
            <xslt:value-of select="@open"/>
          </td>
          <td>
            <xslt:value-of select="@middle"/>
          </td>
          <td>
            <xslt:value-of select="@close"/>
          </td>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@has_name"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@sent_start"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@header"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@separator"/>
          </xslt:call-template>
          <xslt:choose>
            <xslt:when test="@strict">
              <xslt:call-template name="boolean" >
                <xslt:with-param name="value" select="@strict"/>
              </xslt:call-template>
            </xslt:when>
            <xslt:otherwise>
              <td>
                X
              </td>
            </xslt:otherwise>
          </xslt:choose>
        </tr>
      </xslt:for-each>
    </table>
  </xslt:template>

  <xslt:template match="FORMAT">
    <h3>Formatting Settings</h3>
    <table>
      <tr class="TR-HEADER">
        <td>Parameter</td>
        <td>Value</td>
      </tr>
      <tr class="TR-NORMAL">
        <td>Default Indent</td>
        <td>
          <xslt:value-of select="DefaultIndent"/>
        </td>
      </tr>
    </table>
    <xslt:apply-templates select="FormatWords"/>
  </xslt:template>

  <xslt:template match="FormatWords">
    <h4>Format words</h4>
    <table>
      <tr class="TR-HEADER">
        <td>N</td>
        <td>Word</td>
        <td>Indent</td>
        <td>Next Line</td>
        <td>Till Next Tag</td>
        <td>Till Sentence End</td>
        <td>Start Position</td>        
      </tr>
      <xslt:for-each select="FormatWord">
        <tr class="TR-NORMAL">
          <td class="TD-KEY">
            <xslt:value-of select="position()"/>
          </td>
          <td>
            <xslt:value-of select="@word"/>
          </td>
          <td>
            <xslt:value-of select="@indent"/>
          </td>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@next_line"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@range_till_next"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@range_sentence"/>
          </xslt:call-template>
          <td>
            <xslt:value-of select="@pos_sent_start"/>
          </td>
        </tr>
      </xslt:for-each>
    </table>
  </xslt:template>

  <xslt:template match="SYNTAXINFO">
    <h3>Syntax Information Settings</h3>
    <table>
      <tr class="TR-HEADER">
        <td>ID</td>
        <td>Text description</td>
        <td>Underlining color</td>
      </tr>
      <xslt:for-each select="InfoType">
        <tr class="TR-NORMAL">
          <td>
            <xslt:value-of select="@id"/>
          </td>
          <td>
            <xslt:value-of select="@name"/>
          </td>
          <xslt:call-template name="color" >
            <xslt:with-param name="td-color" select="@clr"/>
          </xslt:call-template>
        </tr>
      </xslt:for-each>
    </table>
  </xslt:template>

  <xslt:template match="STYLES">
    <h3>Color Syntax</h3>
    <table>
      <tr class="TR-HEADER">
        <td>ID</td>
        <td>Name</td>
        <td>Extend</td>
        <td>Inlcude</td>        
        <td>Dis. Style</td>
        <td>Dis. Back Color</td>
        <td>Bold</td>
        <td>Italic</td>
        <td>Underline</td>
        <td>Is Text</td>        
        <td>Color</td>
        <td>Back Color</td>
        <td>Img Index</td>
        <td>Containers</td>        
        <td>Keywords</td>
        <td>Blocks</td>
      </tr>
      <xslt:for-each select="Style">
        <tr class="TR-NORMAL">
          <td class="TD-KEY">
            <xslt:value-of select="@id"/>
          </td>
          <td>
            <xslt:value-of select="@name"/>
          </td>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@extend"/>
          </xslt:call-template>
          <td>
            <xslt:value-of select="@include"/>
          </td>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@dstyle"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@dbkclr"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@bold"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@italic"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@underline"/>
          </xslt:call-template>
          <xslt:call-template name="boolean" >
            <xslt:with-param name="value" select="@text"/>
          </xslt:call-template>
          <xslt:call-template name="color" >
            <xslt:with-param name="td-color" select="@clr"/>
          </xslt:call-template>
          <xslt:call-template name="color" >
            <xslt:with-param name="td-color" select="@bkclr"/>
          </xslt:call-template>
          <td>
            <xslt:value-of select="@image"/>
          </td>
          <td>
            <xslt:apply-templates select="Containers"/>
          </td>
          <td>
            <xslt:apply-templates select="Keywords"/>
          </td>
          <td>
            <xslt:apply-templates select="Blocks"/>
          </td>
        </tr>
      </xslt:for-each>
    </table>
  </xslt:template>

  <xslt:template name="color">
    <xslt:param name="td-color" select="string('#FFFFFFFF')"/>
    <xslt:choose>
      <xslt:when test="$td-color > 0">
        <td>
          <xslt:attribute name="style">
            background:rgb(<xslt:value-of select="$td-color mod 256"/>,<xslt:value-of select="($td-color div 256) mod 256"/>,<xslt:value-of select="($td-color div 65536) mod 256"/>)
          </xslt:attribute>
        </td>
      </xslt:when>
      <xslt:when test="$td-color = string('#FFFFFFFF')">
        <td>
          Transparent
        </td>
      </xslt:when>
      <xslt:when test="$td-color = string('#FFFFFF00')">
        <td>
          Automatic
        </td>
      </xslt:when>
      <xslt:otherwise>
        <td>
          <xslt:attribute name="style">
            background-color: <xslt:value-of select="substring(string($td-color), 1, 7)"/>
          </xslt:attribute>
          <xslt:value-of select="$td-color"/>
        </td>
      </xslt:otherwise>
    </xslt:choose>
  </xslt:template>

  <xslt:template name="boolean">
    <xslt:param name="value" select="0"/>
    <xslt:choose>
      <xslt:when test="$value = 1">
        <td>
          <center>X</center>
        </td>
      </xslt:when>
      <xslt:when test="$value = 2">
        <td>
          <center>inherited</center>
        </td>
      </xslt:when>
      <xslt:when test="$value = string('true')">
        <td>
          <center>X</center>
        </td>
      </xslt:when>
      <xslt:otherwise>
        <td></td>
      </xslt:otherwise>
    </xslt:choose>
  </xslt:template>

  <xslt:template match="Keywords">
    <xslt:variable name="id" select="generate-id()"/>
    <center>
      <A href="javascript:ToggleCode('{$id}')">&lt;Keywords&gt;</A>
    </center>
    <DIV id='{$id}' style="DISPLAY: none">
      <table width="100%" cellspacing="0" border="1" cellpadding="0">
        <xslt:for-each select="Keyword">
          <tr class="TR-NORMAL">
            <td>
              <xslt:value-of select="@text"/>
            </td>
          </tr>
        </xslt:for-each>
      </table>
    </DIV>
  </xslt:template>

  <xslt:template match="Containers">
    <xslt:variable name="id" select="generate-id()"/>
    <center>
      <A href="javascript:ToggleCode('{$id}')">&lt;Containers&gt;</A>
    </center>
    <DIV id='{$id}' style="DISPLAY: none">
      <table width="100%" cellspacing="0" border="1" cellpadding="0">
        <xslt:for-each select="Open">
          <tr class="TR-NORMAL">
            <td>
              <xslt:value-of select="@id"/>
            </td>
          </tr>
        </xslt:for-each>
        <xslt:for-each select="Close">
          <tr class="TR-NORMAL">
            <td>
              CanClose <xslt:value-of select="@id"/>
            </td>
          </tr>
        </xslt:for-each>
      </table>
    </DIV>
  </xslt:template>

  <xslt:template match="Blocks">
    <xslt:variable name="id" select="generate-id()"/>
    <center>
      <A href="javascript:ToggleCode('{$id}')">&lt;Blocks&gt;</A>
    </center>
    <DIV id='{$id}' style='DISPLAY: none'>
      <table width="100%" cellspacing="0" border="1" cellpadding="0">
        <tr class="TR-HEADER">
          <td>Start</td>
          <td>End</td>
        </tr>
        <xslt:for-each select="Block">
          <tr class="TR-NORMAL">
            <td>
              <xslt:value-of select="@open"/>
            </td>
            <td>
              <xslt:value-of select="@close"/>
            </td>
          </tr>
        </xslt:for-each>
      </table>
    </DIV>
  </xslt:template>

</xslt:stylesheet>
