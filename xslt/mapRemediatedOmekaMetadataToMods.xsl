<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="xml" indent = "yes" encoding="UTF-8"/>
  <xsl:template match="/">
    <modsCollection>
      <xsl:attribute name="xmlns">http://www.loc.gov/mods/v3</xsl:attribute>
      <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd</xsl:attribute>
      <xsl:apply-templates select="root/row"/>
    </modsCollection>
  </xsl:template>
  <xsl:template match="row">
    <mods>
      <!-- fcd1, 03/26/14: name of template is based on the MODS element it creates -->
      <xsl:call-template name="Identifier"/>
      <xsl:call-template name="TitleInfo"/>
      <xsl:call-template name="PhysicalDescription"/>
      <xsl:call-template name="OriginInfo"/>
      <xsl:call-template name="Location"/>
      <xsl:call-template name="RelatedItemTitleInfoTitle"/>
      <xsl:call-template name="Note"/>
      <xsl:call-template name="NameNamePart"/>
      <xsl:call-template name="Subject"/>
      <xsl:call-template name="Abstract"/>
      <xsl:call-template name="TypeOfResource"/>
      <xsl:call-template name="Language"/>
      <xsl:call-template name="RecordInfo"/>
      <xsl:call-template name="AccessCondition"/>
    </mods>
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
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_PublicationPlace')]">
      <xsl:if test=" . != '' ">
	<place><placeTerm type="text"><xsl:value-of select="."/></placeTerm></place>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <name><nameTerm> -->
  <!-- fcd1, 04/23/14: I don't think nameTerm exists in MODS, why did I code the following? -->
  <xsl:template name="NameNameTerm">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Creator')]">
      <xsl:if test=" . != '' ">
	<name><nameTerm type="text"><xsl:value-of select="."/></nameTerm></name>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <name><namePart> -->
  <xsl:template name="NameNamePart">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Creator')]">
      <xsl:if test=" . != '' ">
	<name><namePart><xsl:value-of select="."/></namePart></name>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Contributor')]">
      <xsl:if test=" . != '' ">
	<name><namePart><xsl:value-of select="."/></namePart></name>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <topic> -->
  <xsl:template name="Topic">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Subject')]">
      <xsl:if test=" . != '' ">
	<topic><xsl:value-of select="."/></topic>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <temporal> -->
  <xsl:template name="Temporal">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Coverage')]">
      <xsl:if test=" . != '' ">
	<temporal><xsl:value-of select="."/></temporal>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_AdditionalItemMetadata_-_TemporalCoverage')]">
      <xsl:if test=" . != '' ">
	<temporal><xsl:value-of select="."/></temporal>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <geographic> -->
  <xsl:template name="Geographic">
    <xsl:for-each select="*[starts-with(name(), 'item_-_AdditionalItemMetadata_-_SpatialCoverage')]">
      <xsl:if test=" . != '' ">
	<geographic><xsl:value-of select="."/></geographic>
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
      <xsl:call-template name="Temporal"/>
      <xsl:call-template name="Geographic"/>
    </subject>
  </xsl:template>
  
  <!-- fcd1, 04/23/14: MODS <form> -->
  <xsl:template name="Form">
      <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_FormGenre')]">
	<xsl:if test=" . != '' ">
	  <form><xsl:value-of select="."/></form>
	</xsl:if>
      </xsl:for-each>
      <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Format')]">
	<xsl:if test=" . != '' ">
	  <form><xsl:value-of select="."/></form>
	</xsl:if>
      </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <physicalDescription>, not repeatable -->
  <!-- fcd1, 03/26/14: contains <form>, <digitalOrigin> -->
  <xsl:template name="PhysicalDescription">
    <physicalDescription>
      <xsl:call-template name="DigitalOrigin"/>
      <xsl:call-template name="Form"/>
    </physicalDescription>
  </xsl:template>
  
  <!-- fcd1, 04/23/14: MODS <publisher> -->
  <xsl:template name="Publisher">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Publisher')]">
      <xsl:if test=" . != '' ">
	<publisher><xsl:value-of select="."/></publisher>
      </xsl:if>
    </xsl:for-each>
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
      <xsl:apply-templates select="item_-_DublinCore_-_Date"/>
      <xsl:apply-templates select="item_-_MODS_-_PublicationDate"/>
      <xsl:call-template name="Publisher"/>
      <xsl:call-template name="PlacePlaceTerm"/>
    </originInfo>
  </xsl:template>
  
  <!-- fcd1, 04/23/14: MODS <recordContentSource> Hard-coded -->
  <xsl:template name="RecordContentSource">
    <recordContentSource authority="marcorg">NNC</recordContentSource>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <recordOrigin> Hard-coded -->
  <xsl:template name="RecordOrigin">
    <recordOrigin>Human created, edited in general conformance to MODS Guideline (Version 3).</recordOrigin>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <recordInfo> Not repeatable -->
  <!-- contains <languageOfCataloging>, <recordContentSource>, <recordOrigin> -->
  <xsl:template name="RecordInfo">
    <recordInfo>
      <xsl:call-template name="LanguageOfCataloging"/>
      <xsl:call-template name="RecordContentSource"/>
      <xsl:call-template name="RecordOrigin"/>
    </recordInfo>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: <dateCreated encoding="w3cdtf" point="start" keyDate="yes"> -->
  <!-- fcd1, 03/26/14: code assumes the date is already in the correct format in the remediated metadata> -->
  <xsl:template match="item_-_MODS_-_KeyDate_-_Single_Start">
    <xsl:if test=" . != '' ">
      <!-- fcd1, 04/29/14: move point="start" attribute to <xsl:if ... > -->
      <!-- because we do not want to include it if there is no end date> -->
      <dateCreated encoding="w3cdtf" keyDate="yes" >
	<xsl:if test=" ../item_-_MODS_-_KeyDate_-_End != '' ">
	  <xsl:attribute name="point">start</xsl:attribute>
	</xsl:if>
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

  <!-- fcd1, 04/23/14: <dateCreated> for DC Date-->
  <xsl:template match="item_-_DublinCore_-_Date">
    <xsl:if test=" . != '' ">
      <dateCreated>
	<xsl:value-of select="."/>
      </dateCreated>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 04/23/14: <dateCreated> for MODS Publication Date -->
  <xsl:template match="item_-_MODS_-_PublicationDate">
    <xsl:if test=" . != '' ">
      <dateCreated>
	<xsl:value-of select="."/>
      </dateCreated>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <languageOfCatalogin>, auto-generate -->
  <xsl:template name="LanguageOfCataloging">
    <languageOfCataloging><languageTerm type="code" authority="iso639-2b">eng</languageTerm></languageOfCataloging>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <shelfLocator> -->
  <xsl:template name="ShelfLocator">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_ShelfLocation')]">
      <xsl:if test=" . != '' ">
	<shelfLocator><xsl:value-of select="."/></shelfLocator>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="SubLocation">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Subrepository')]">
      <xsl:if test=" . != '' ">
	<subLocation><xsl:value-of select="."/></subLocation>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <holdingSimple><copyInformation>, -->
  <!-- fcd1, 04/23/14: contains <shelfLocator> -->
  <!-- fcd1, 04/23/14: contains <subLocation> -->
  <xsl:template name="HoldingSimpleCopyInformation">
    <holdingSimple><copyInformation>
      <xsl:call-template name="SubLocation"/>
      <xsl:call-template name="ShelfLocator"/>
    </copyInformation></holdingSimple>
  </xsl:template>

  <!-- fcd1, 04/24/14: MODS <url>, -->
  <!-- contains item-in-context url, points to an exhibition page containing item -->
  <xsl:template name="Url">
    <xsl:variable name="varItemID" select="item_-_itemId/."/>
    <xsl:for-each select="/root/ItemInContext">
      <xsl:if test="@itemID=$varItemID">
	<url access="object in context" usage="primary display">
	  <xsl:value-of select="." />
	</url>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <location>, -->
  <!-- fcd1, 03/26/14: contains <holdingSimple><shelfLocator> -->
  <!-- fcd1, 04/23/14: contains <physicalLocation> -->
  <xsl:template name="Location">
    <location>
      <xsl:apply-templates select="item_-_MODS_-_RepositoryName_-_code"/>
      <xsl:call-template name="Url"/>
      <xsl:call-template name="HoldingSimpleCopyInformation"/>
    </location>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <relatedItem<titleIfo><title> -->
  <!-- Handles the collection name, as stored in Omeka, as well as -->
  <!-- the MODS Collection field -->
  <!-- fcd1, 05/16/14: need to fix the MODS Collection part, do not want -->
  <!-- to create an empty <relatedItem/> if there is not MODS Collection value -->
  <!-- maybe I can move the <relatedItem> into the for-each loop, like I -->
  <!-- did the Omeka Collection (should only be one, so makes no difference -->
  <xsl:template name="RelatedItemTitleInfoTitle">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Collection')]">
      <xsl:if test=" . != '' ">
	<relatedItem displayLabel="Collection" type="host">
	  <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
	</relatedItem>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_OmekaCollection')]">
      <xsl:if test=" . != '' ">
	<relatedItem displayLabel="Project" type="host">
	  <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
	</relatedItem>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <note> -->
  <xsl:template name="Note">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Notes')]">
      <!-- fcd1, 04/25/14: Do not process an item_-_MODS_-_Notes that -->
      <!-- contains "Original filename", since we are getting the origina -->
      <!-- filename from item_-_OriginalFileLoadedIntoOmeka_ -->
      <xsl:if test=" . != '' and not(contains(.,'Original filename:'))">
	<note><xsl:value-of select="."/></note>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_AdditionalItemMetadata_-_Provenance')]">
      <xsl:if test=" . != '' ">
	<note type="ownership"><xsl:value-of select="."/></note>
      </xsl:if>
    </xsl:for-each>
    <!-- fcd1, 04/25/14: spoke to Eric, he prefers one <note> element per filename -->
    <xsl:for-each select="*[starts-with(name(), 'item_-_OriginalFileLoadedIntoOmeka_')]">
      <xsl:if test=" . != '' ">
	<!-- fcd1, 04/25/14: assume content already contains "original filename: " -->
	<!-- which is the case for the Frances Perkins remediated data -->
	<note><xsl:value-of select="."/></note>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <abstract> -->
  <xsl:template name="Abstract">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Description')]">
      <xsl:if test=" . != '' ">
	<abstract><xsl:value-of select="."/></abstract>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <identifier> -->
  <xsl:template name="Identifier">
    <xsl:for-each select="*[starts-with(name(), 'item_-_itemId')]">
      <xsl:if test=" . != '' ">
	<identifier type="Omeka ID"> <xsl:value-of select='concat("omeka_",format-number(., "000000") )' /></identifier>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Identifier')]">
      <xsl:if test=" . != '' ">
	<identifier><xsl:value-of select="."/></identifier>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <typeOfResource> -->
  <!-- use the value in itemType, but make it all lowercase -->
  <!-- fcd1, 05/16/14: CUL specs specify that, if no itemType is given in the metadata, -->
  <!-- then generate one based on the file type of the associated loaded files. THIS IS NOT IMPLEMENTED -->
  <!-- It is probably easier to put in the itemType in the remediated data, based on the file type -->
  <xsl:template name="TypeOfResource">
    <xsl:for-each select="*[starts-with(name(), 'item_-_ItemType')]">
      <xsl:if test=" . != '' ">
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<typeOfResource><xsl:value-of select="translate(.,$uppercase,$smallcase)"/></typeOfResource>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <language> -->
  <!-- fcd1, 04/23/14: software assumes the field(s) item_-_DublinCore_-_Language -->
  <!-- contain the language in iso639-2 format -->
  <xsl:template name="Language">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Language')]">
      <xsl:if test=" . != '' ">
	<language><languageTerm type="code" authority="iso639-2b"><xsl:value-of select="."/></languageTerm></language>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <accessCondition> -->
  <xsl:template name="AccessCondition">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Rights')]">
      <xsl:if test=" . != '' ">
	<accessCondition><xsl:value-of select="."/></accessCondition>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="PhysicalLocation">
    <physicalLocation type="code" authority="marcorg"><xsl:value-of select="."/></physicalLocation>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <physicalLocation type="code"> -->
  <!-- fcd1, 03/24/14: Assumes metadata being process has been remediated and contains correct and valid code -->
  <xsl:template match="item_-_MODS_-_RepositoryName_-_code">
    <xsl:if test=" . != '' ">
      <physicalLocation type="code" authority="marcorg">
	<xsl:value-of select="."/>
      </physicalLocation>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
