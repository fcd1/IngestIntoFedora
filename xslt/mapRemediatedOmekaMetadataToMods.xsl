<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent = "yes" />
  <xsl:template match="/">
    <modsCollection>
      <xsl:apply-templates select="root/row"/>
    </modsCollection>
  </xsl:template>
  <xsl:template match="row">
    <mods>
      <xsl:apply-templates select="item_-_itemId"/>
      <!-- fcd1, 03/26/14: name of template is based on the MODS element it creates -->
      <xsl:call-template name="TitleInfo"/>
      <xsl:call-template name="PhysicalDescription"/>
      <xsl:call-template name="OriginInfo"/>
      <xsl:call-template name="LanguageOfCataloging"/>
      <xsl:call-template name="Location"/>
      <xsl:call-template name="RelatedItemTitleInfoTitle"/>
      <xsl:call-template name="Note"/>
      <xsl:call-template name="NameNameTerm"/>
      <xsl:call-template name="Subject"/>
    </mods>
  </xsl:template>
  
  <xsl:template match="item_-_itemId">
    <identifier><xsl:value-of select="."/></identifier>
  </xsl:template>
  
  <xsl:template match="*[starts-with(name(), 'item_-_DublinCore_-_Title')]">
    <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <titleInfo><title> -->
  <xsl:template name="TitleInfo">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Title')]">
      <xsl:if test=" . != '' ">
	<titleInfo><title><xsl:value-of select="."/></title></titleInfo>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <digitalOrigin> -->
  <xsl:template name="DigitalOrigin">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_DigitalOrigin')]">
      <xsl:if test=" . != '' ">
	<digitalOrigin><xsl:value-of select="."/></digitalOrigin>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <place><placeTerm> -->
  <xsl:template name="PlacePlaceTerm">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_PlaceofOrigin')]">
      <xsl:if test=" . != '' ">
	<place><placeTerm type="text"><xsl:value-of select="."/></placeTerm></place>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <name><nameTerm> -->
  <xsl:template name="NameNameTerm">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Creator')]">
      <xsl:if test=" . != '' ">
	<name><nameTerm type="text"><xsl:value-of select="."/></nameTerm></name>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <topic> -->
  <xsl:template name="Topic">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Subject]">
      <xsl:if test=" . != '' ">
	<topic><xsl:value-of select="."/></topic>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <subject> -->
  <!-- <subject> can contain <topic>, as well as <geographic> and <temporal> -->
  <!-- we will create just one <subject> to contain all the subelements. -->
  <!-- Contains <topic>, <???> -->
  <xsl:template name="Subject">
    <subject>
      <xsl:call-template name="Topic"/>
    </subject>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <physicalDescription>, not repeatable -->
  <!-- fcd1, 03/26/14: contains <form>, <digitalOrigin> -->
  <xsl:template name="PhysicalDescription">
    <physicalDescription>
      <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_FormGenre')]">
	<xsl:if test=" . != '' ">
	  <form><xsl:value-of select="."/></form>
	</xsl:if>
      </xsl:for-each>
      <xsl:call-template name="DigitalOrigin"/>
    </physicalDescription>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <originInfo> ?? is this repeatable ?? -->
  <!-- Even if it is, should/can I include all subelements in just one instance? -->
  <!-- contains <dateCreated>, <place><placeTerm> -->
  <xsl:template name="OriginInfo">
    <originInfo>
      <!-- fcd1, 03/26/14: Code assumes there is only one start date (the keyDate) -->
      <!-- and, if present, only one end date -->
      <xsl:apply-templates select="item_-_MODS_-_KeyDate_-_Single_Start"/>
      <xsl:apply-templates select="item_-_MODS_-_KeyDate_-_End"/>
      <xsl:call-template name="PlacePlaceTerm"/>
    </originInfo>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: <dateCreated encoding="w3cdtf" point="start" keyDate="yes"> -->
  <!-- fcd1, 03/26/14: code assumes the date is already in the correct format in the remediated metadata> -->
  <xsl:template match="item_-_MODS_-_KeyDate_-_Single_Start">
    <xsl:if test=" . != '' ">
      <dateCreated encoding="w3cdtf" point="start" keyDate="yes" >
	<xsl:if test=" ../item_-_MODS_-_TypeofDate != '' ">
	  <xsl:attribute name="qualifier"><xsl:value-of select="../item_-_MODS_-_TypeofDate"/></xsl:attribute>
	</xsl:if>
	<xsl:value-of select="."/>
      </dateCreated>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 03/26/14: <dateCreated encoding="w3cdtf" point="end"> -->
  <!-- fcd1, 03/26/14: code assumes the date is already in the correct format in the remediated metadata> -->
  <xsl:template match="item_-_MODS_-_KeyDate_-_End">
    <xsl:if test=" . != '' ">
      <dateCreated encoding="w3cdtf" point="end">
	<xsl:value-of select="."/>
      </dateCreated>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <languageOfCatalogin>, auto-generate -->
  <xsl:template name="LanguageOfCataloging">
    <languageOfCataloging><languageTerm type="code" authority="iso639-2b">eng</languageTerm></languageOfCataloging>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <holdingSimple><shelfLocator> -->
  <xsl:template name="HoldingSimpleShelfLocator">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_ShelfLocation')]">
      <xsl:if test=" . != '' ">
	<holdingSimple><shelfLocator><xsl:value-of select="."/></shelfLocator></holdingSimple>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <location>, -->
  <!-- fcd1, 03/26/14: contains <holdingSimple><shelfLocator> -->
  <xsl:template name="Location">
    <location>
      <xsl:call-template name="HoldingSimpleShelfLocator"/>
    </location>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <relatedItem<titleIfo><title> -->
  <!-- Handles the collection name, as stored in Omeka -->
  <xsl:template name="RelatedItemTitleInfoTitle">
    <relatedItem displayLabel="Project" type="host">
      <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Collection')]">
	<xsl:if test=" . != '' ">
	  <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
	</xsl:if>
      </xsl:for-each>
    </relatedItem>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <note> -->
  <xsl:template name="Note">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Notes')]">
      <xsl:if test=" . != '' ">
	<note><xsl:value-of select="."/></note>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
