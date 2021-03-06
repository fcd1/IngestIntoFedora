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
      <xsl:call-template name="RelatedItem"/>
      <xsl:call-template name="Note"/>
      <xsl:call-template name="NameNamePart"/>
      <xsl:call-template name="Subject"/>
      <xsl:call-template name="Abstract"/>
      <xsl:call-template name="TypeOfResource"/>
      <xsl:call-template name="Language"/>
      <xsl:call-template name="RecordInfo"/>
      <xsl:call-template name="AccessCondition"/>
      <xsl:call-template name="Genre"/>
    </mods>
  </xsl:template>
  
  <xsl:template match="item_-_DublinCore_-_Title">
    <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
  </xsl:template>

  <xsl:template name="DC_Title_2">
      <xsl:if test="item_-_DublinCore_-_Title_2/. != '' ">
	<!-- fcd1, 07/22/14: type attribute is required per CUL-specs for -->
	<!-- a "secondary" title -->
	<xsl:choose>
	  <xsl:when test="item_-_DublinCore_-_Title_2_-_Attribute/. = ''">
	    <xsl:message terminate="yes">
	      ---- !!!! ---- ERROR: No attribute for secondary title ---- !!!! ----
	    </xsl:message>
	  </xsl:when>
	  <xsl:otherwise>
	    <titleInfo>
	      <xsl:attribute name="type"><xsl:value-of select="item_-_DublinCore_-_Title_2_-_Attribute/."/></xsl:attribute>
	      <title><xsl:value-of select="item_-_DublinCore_-_Title_2/."/>
	      </title>
	    </titleInfo>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <titleInfo><title> -->
  <xsl:template name="TitleInfo">
    <!-- fcd1, 07/22/14: section which handles main title -->
    <xsl:apply-templates select="item_-_DublinCore_-_Title"/>
    <!-- fcd1, 07/22/14: section which handles secondary title(s) -->
    <xsl:call-template name="DC_Title_2"/>
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
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Coverage')]">
      <xsl:if test=" . != '' ">
	<topic><xsl:value-of select="."/></topic>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <temporal> -->
  <xsl:template name="Temporal">
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
    <!-- fcd1, 06/25/14: add following so we only create wrapper element it there are -->
    <!-- subelements to wrap. If we don't check, an empty <subject/> will be created -->
    <xsl:if test="(*[starts-with(name(), 'item_-_DublinCore_-_Subject')]/. != '')
		  or
		  (*[starts-with(name(), 'item_-_AdditionalItemMetadata_-_TemporalCoverage')]/. != '')
		  or
		  (*[starts-with(name(), 'item_-_AdditionalItemMetadata_-_SpatialCoverage')]/. != '')
		  or
		  (*[starts-with(name(), 'item_-_DublinCore_-_Coverage')]/. != '')">
      <subject>
	<xsl:call-template name="Topic"/>
	<xsl:call-template name="Temporal"/>
	<xsl:call-template name="Geographic"/>
      </subject>
    </xsl:if>
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
      <!-- fcd1, 08/04/14 -->
      <!-- for <item_-_ItemType_-_text>, need to remove "Original Format: " -->
      <!-- which may appear at the start of its content -->
      <xsl:for-each select="*[starts-with(name(), 'item_-_ItemType_-_text')]">
	<xsl:if test=" . != '' ">
	  <xsl:choose>
	    <xsl:when test="starts-with(.,'Original Format: ')">
	      <form><xsl:value-of select="substring-after(.,'Original Format: ')"/></form>
	    </xsl:when>
	    <xsl:otherwise>
	      <form><xsl:value-of select="."/></form>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:if>
      </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 08/04/14: MODS <extent> -->
  <xsl:template name="Extent">
      <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_PhysicalDescription')]">
	<xsl:if test=" . != '' ">
	  <extent><xsl:value-of select="."/></extent>
	</xsl:if>
      </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <physicalDescription>, not repeatable -->
  <!-- fcd1, 03/26/14: contains <form>, <digitalOrigin> -->
  <!-- fcd1, 07/11/14: add call to template handling Original Format -->
  <!-- and Physical Dimension instances in George Plimpton -->
  <xsl:template name="PhysicalDescription">
    <physicalDescription>
      <xsl:call-template name="DigitalOrigin"/>
      <xsl:call-template name="Extent"/>
      <xsl:call-template name="Form"/>
      <xsl:if test="contains(item_-_OmekaCollection,'George Arthur Plimpton')">
	<xsl:call-template name="GeorgePlimptonSpecific"/>
      </xsl:if>
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
      <xsl:call-template name="DublinCore_-_Date"/>
      <xsl:call-template name="MODS_-_PublicationDate"/>
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
    <recordOrigin>Created and edited in general conformance to MODS Guideline (Version 3).</recordOrigin>
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
      <dateCreated>
	<!-- fcd1, 06/10/14: if negative date (i.e. BC), use the iso8601 encoding. -->
	<!-- Else, use w3cdtf -->
	<xsl:choose>
	  <xsl:when test="starts-with(.,'-')">
	    <xsl:attribute name="encoding">iso8601</xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
	  </xsl:otherwise>
	</xsl:choose>
	<!-- fcd1, 06/10/14: Moved the keyDate attribute here, instead of -->
	<!-- hard-coding it in the dateCreated start tag above -->
	<!-- only reason I did that is to keep the original ordering -->
	<!-- of attributes I had before I made the encoding attribute change -->
	<!-- to handle iso8601 encoding -->
	<xsl:attribute name="keyDate">yes</xsl:attribute>
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
      <dateCreated>
	<!-- fcd1, 06/10/14: if negative date (i.e. BC), use the iso8601 encoding. -->
	<!-- Else, use w3cdtf -->
	<xsl:choose>
	  <xsl:when test="starts-with(.,'-')">
	    <xsl:attribute name="encoding">iso8601</xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
	  </xsl:otherwise>
	</xsl:choose>
	<!-- fcd1, 06/10/14: Moved the point attribute here, instead of -->
	<!-- hard-coding it in the dateCreated start tag above -->
	<!-- only reason I did that is to keep the original ordering -->
	<!-- of attributes I had before I made the encoding attribute change -->
	<!-- to handle iso8601 encoding -->
	<xsl:attribute name="point">end</xsl:attribute>
	<xsl:value-of select="."/>
      </dateCreated>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 04/23/14: <dateCreated> for DC Date-->
  <xsl:template name="DublinCore_-_Date">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Date')]">
      <xsl:if test=" . != '' ">
	<dateCreated>
	  <xsl:value-of select="."/>
	</dateCreated>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: <dateCreated> for MODS Publication Date -->
  <xsl:template name="MODS_-_PublicationDate">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_PublicationDate')]">
      <xsl:if test=" . != '' ">
	<dateCreated>
	  <xsl:value-of select="."/>
	</dateCreated>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <languageOfCatalogin>, auto-generate -->
  <xsl:template name="LanguageOfCataloging">
    <languageOfCataloging><languageTerm type="code" authority="iso639-2b">eng</languageTerm></languageOfCataloging>
  </xsl:template>
  
  <!-- fcd1, 03/26/14: MODS <shelfLocator> -->
  <xsl:template name="ShelfLocator">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_ShelfLocation')]">
      <xsl:if test=" . != '' ">
	<shelfLocator><xsl:value-of select="normalize-space(.)"/></shelfLocator>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="SubLocation">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Subrepository')]">
      <xsl:if test=" . != '' ">
	<subLocation><xsl:value-of select="normalize-space(.)"/></subLocation>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <holdingSimple><copyInformation>, -->
  <!-- fcd1, 04/23/14: contains <shelfLocator> -->
  <!-- fcd1, 04/23/14: contains <subLocation> -->
  <xsl:template name="HoldingSimpleCopyInformation">
    <!-- fcd1, 06/25/14: add following so we only create wrapper element it there are -->
    <!-- subelements to wrap. If we don't check, an empty <copyInformation/> will be created -->
    <xsl:if test="(*[starts-with(name(), 'item_-_MODS_-_Subrepository')]/. != '')
		  or 
		  (item_-_MODS_-_ShelfLocation/. !='')">
      <holdingSimple><copyInformation>
	  <xsl:call-template name="SubLocation"/>
	  <xsl:call-template name="ShelfLocator"/>
      </copyInformation></holdingSimple>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 04/24/14: MODS <url>, -->
  <!-- contains item-in-context url, points to an exhibition page containing item -->
  <!-- fcd1, 07/31/14: Old version, so renamed to UrlOldVersionNotUsedAnymore -->
  <!-- to keep it from being used. Old name was Url -->
  <!-- This old version used the item_in_context info generated from CulOmekaXml -->
  <!-- and appended to the prepped remediated metadata file. This info is now -->
  <!-- included in the remediated metadata file when it is generated by the -->
  <!-- Metadata group, so no need to include the CulOmekaXml-generated info anymore -->
  <xsl:template name="UrlOldVersionNotUsedAnymore">
    <xsl:variable name="varItemID" select="item_-_itemId/."/>
    <xsl:for-each select="/root/ItemInContext">
      <xsl:if test="@itemID=$varItemID">
	<url access="object in context" usage="primary display">
	  <xsl:value-of select="." />
	</url>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 07/31/14: MODS <url>, -->
  <!-- contains item-in-context url, points to an exhibition page containing item -->
  <!-- We only want one item-in-context url per item. -->
  <!-- In some Omeka collections, items may have more that one item-in-context value. -->
  <!-- In these cases, the name of the elements are <item_in_context_1>, -->
  <!-- <item_in_context_2>, ... -->
  <!-- In other Omeka collections, items may have only one item-in-context value. -->
  <!-- In these cases, the name of the element is <item_in_context> -->
  <xsl:template name="Url">
    <xsl:choose>
      <xsl:when test="item_in_context_1/. != '' ">
	<url access="object in context" usage="primary display">
	  <xsl:value-of select="item_in_context_1/." />
	</url>
      </xsl:when>
      <xsl:when test="item_in_context/. != '' ">
	<url access="object in context" usage="primary display">
	  <xsl:value-of select="item_in_context/." />
	</url>
      </xsl:when>
    </xsl:choose>
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

  <!-- fcd1, 05/19/14: Following is used to populate subelements of -->
  <!-- <relatedItem type="host" displayLabel="Project" -->
  <!-- containing the Omeka Collection information. -->
  <xsl:template match="item_-_OmekaCollection">
    <xsl:if test=" . != '' ">
	  <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 05/19/14: Following is used to populate subelements of -->
  <!-- <relatedItem type="host" displayLabel="Project" -->
  <!-- containig the project URL -->
  <xsl:template match="project_URL">
    <xsl:if test=" . != '' ">
	  <location><url><xsl:value-of select="."/></url></location>
    </xsl:if>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <relatedItem<titleIfo><title> -->
  <!-- Handles the collection name, as stored in Omeka, as well as -->
  <!-- as the project URL, and the MODS Collection field -->
  <!-- fcd1, 06/03/14: also handles the DC Source field -->
  <!-- fcd1, 07/08/14: Note that the project URL may not be present -->
  <!-- in the remediated metadata, so in that case need to generate it -->
  <xsl:template name="RelatedItem">
    <relatedItem displayLabel="Project" type="host">
      <xsl:apply-templates select="item_-_OmekaCollection"/>
      <!-- fcd1, 07/08/14: In the remediated data for certain collections -->
      <!-- the <project_URL> element is not included. Therefore, the code -->
      <!-- needs to generate it. According to the CUL mapping specs -->
      <!-- the content is the resolver URL as found in CLIO -->
      <xsl:choose>
	<xsl:when test="item_-_OmekaCollection = 'Music at Columbia: The First 100 Years'">
          <location><url>http://www.columbia.edu/cgi-bin/cul/resolve?clio9628664</url></location>
	</xsl:when>
	<xsl:when test="item_-_OmekaCollection = 'The People in the Books: Hebraica and Judaica Manuscripts from Columbia University Libraries'">
          <location><url>http://www.columbia.edu/cgi-bin/cul/resolve?clio9680681</url></location>
	</xsl:when>
	<xsl:otherwise>
	  <!-- fcd1, 07/08/14: all other collections should have the <project_URL> element -->
	  <xsl:apply-templates select="project_URL"/>
	</xsl:otherwise>
      </xsl:choose>
    </relatedItem>
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Collection')]">
      <xsl:if test=" . != '' ">
	<relatedItem displayLabel="Collection" type="host">
	  <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
	</relatedItem>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Source')]">
      <xsl:if test=" . != '' ">
	<relatedItem type="original">
	  <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
	</relatedItem>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Relation')]">
      <xsl:if test=" . != '' ">
	<relatedItem>
	  <titleInfo><title><xsl:value-of select="."/></title></titleInfo>
	</relatedItem>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- fcd1, 07/22/14: Customized template for the Frances Perkins collection -->
  <xsl:template name="Omeka_OriginalFileLoadedIntoOmeka_FrancesPerkins">
    <!-- fcd1, 04/25/14: spoke to Eric, he prefers one <note> element per filename -->
    <xsl:for-each select="*[starts-with(name(), 'item_-_OriginalFileLoadedIntoOmeka')]">
      <xsl:if test=" . != '' ">
	<xsl:variable name="francesperkinsprefix"
		      select="'original filename: perkins_'"/>
	<xsl:choose>
	  <xsl:when test="starts-with(.,$francesperkinsprefix)">
	    <xsl:variable name="filenamewithoutprefix"
			  select="concat('original filename: ', substring-after(.,$francesperkinsprefix))"/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($filenamewithoutprefix,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="filenamewithoutprefix" select="."/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($filenamewithoutprefix,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 07/22/14: Customized template for the George Plimpton collection -->
  <!-- fcd1, 07/23/14: in fstore, all files are of the form PLMPTN_096_001.tif -->
  <!-- However, in Omeka, the filenames may have a lowercase prefix, i.e plmptn_031_001.jpg -->
  <!-- Code will uppercase these. -->
  <xsl:template name="Omeka_OriginalFileLoadedIntoOmeka_GeorgePlimpton">
    <!-- fcd1, 04/25/14: spoke to Eric, he prefers one <note> element per filename -->
    <xsl:for-each select="*[starts-with(name(), 'item_-_OriginalFileLoadedIntoOmeka')]">
      <xsl:if test=" . != '' ">
	<xsl:variable name="georgeplimptonlowercaseprefix"
		      select="'original filename: plmptn_'"/>
	<xsl:variable name="georgeplimptonuppercaseprefix"
		      select="'original filename: PLMPTN_'"/>
	<xsl:choose>
	  <xsl:when test="starts-with(.,$georgeplimptonlowercaseprefix)">
	    <xsl:variable name="filenamecorrectcase"
			  select="concat($georgeplimptonuppercaseprefix,
				  substring-after(.,$georgeplimptonlowercaseprefix))"/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($filenamecorrectcase,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="filenamecorrectcase" select="."/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($filenamecorrectcase,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 07/24/14: Customized template for the Ballets Russes collection. -->
  <!-- In fstore, all files are of the form 07-10-01.tif. However, in Omeka, -->
  <!-- all the filenames have a prefix, i.e ballet_russe_07-10-01.jpg -->
  <!-- Code will remove the prefix, as well as replacing .jpg with .tif -->
  <xsl:template name="Omeka_OriginalFileLoadedIntoOmeka_BalletsRusses">
    <!-- fcd1, 04/25/14: spoke to Eric, he prefers one <note> element per filename -->
    <xsl:for-each select="*[starts-with(name(), 'item_-_OriginalFileLoadedIntoOmeka')]">
      <xsl:if test=" . != '' ">
	<xsl:variable name="ballets_russes_omeka_prefix"
		      select="'original filename: ballet_russe_'"/>
	<xsl:variable name="ballets_russes_pdcd_prefix"
		      select="'original filename: '"/>
	<xsl:choose>
	  <xsl:when test="starts-with(.,$ballets_russes_omeka_prefix)">
	    <xsl:variable name="tifffilename"
			  select="concat($ballets_russes_pdcd_prefix,
				  substring-after(.,$ballets_russes_omeka_prefix))"/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($tifffilename,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="tifffilename" select="."/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($tifffilename,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 07/25/14: template for filenames with different prefixes between -->
  <!-- the JPEG filename used in Omeka and the filename of the PDCD-generated TIFF in fstore -->
  <!-- ** Frances Perkins: Omeka file may have prefix: perkins_090074225.jpg in Omeka, -->
  <!-- 090074225.tif in fstore -->
  <!-- ** Ballets Russes: ballet_russe_07-10-01.jpg  in Omeka and -->
  <!-- 07-10-01.jpg  in fstore -->
  <!-- ** Plimpon: all files are of the form PLMPTN_096_001.tif in fstore-->
  <!-- However, in Omeka, the filenames may have a lowercase prefix, i.e plmptn_031_001.jpg -->
  <!-- For all collections, the code will remove/normalize the prefix, as well as replace -->
  <!-- the .jpg with .tif -->
  <xsl:template name="Omeka_OriginalFileLoadedIntoOmeka_normalize_prefix">

    <!-- fcd1, 07/25/14: Set the Omeka prefix -->
    <xsl:variable name="omeka_prefix">
      <xsl:choose>
	<xsl:when test="contains(item_-_OmekaCollection,'Frances Perkins: The Woman Behind the New Deal')">
	  <xsl:value-of select="'original filename: perkins_'"/>
	</xsl:when>
	<xsl:when test="contains(item_-_OmekaCollection,'George Arthur Plimpton')">
	  <xsl:value-of select="'original filename: plmptn_'"/>
	</xsl:when>
	<xsl:when test="contains(item_-_OmekaCollection,'Sergei Diaghilev and Beyond: Les Ballets Russes')">
	  <xsl:value-of select="'original filename: ballet_russe_'"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="'original filename: '"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- fcd1, 07/25/14: Set the PDCD prefix -->
    <xsl:variable name="pdcd_prefix">
      <xsl:choose>
	<xsl:when test="contains(item_-_OmekaCollection,'Frances Perkins: The Woman Behind the New Deal')">
	  <xsl:value-of select="'original filename: '"/>
	</xsl:when>
	<xsl:when test="contains(item_-_OmekaCollection,'George Arthur Plimpton')">
	  <xsl:value-of select="'original filename: PLMPTN_'"/>
	</xsl:when>
	<xsl:when test="contains(item_-_OmekaCollection,'Sergei Diaghilev and Beyond: Les Ballets Russes')">
	  <xsl:value-of select="'original filename: '"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="'original filename: '"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- fcd1, 04/25/14: spoke to Eric, he prefers one <note> element per filename -->
    <xsl:for-each select="*[starts-with(name(), 'item_-_OriginalFileLoadedIntoOmeka')]">
      <xsl:if test=" . != '' ">
	<xsl:choose>
	  <xsl:when test="starts-with(.,$omeka_prefix)">
	    <xsl:variable name="tifffilename"
			  select="concat($pdcd_prefix,
				  substring-after(.,$omeka_prefix))"/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($tifffilename,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="tifffilename" select="."/>
	    <xsl:variable name="filenamewithtiffsuffix"
			  select="concat(substring-before($tifffilename,'.jpg'),'.tif')"/>
	    <note><xsl:value-of select="$filenamewithtiffsuffix"/></note>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="Omeka_OriginalFileLoadedIntoOmeka">
    <!-- fcd1, 04/25/14: spoke to Eric, he prefers one <note> element per filename -->
    <xsl:for-each select="*[starts-with(name(), 'item_-_OriginalFileLoadedIntoOmeka')]">
      <xsl:if test=" . != '' ">
	<note><xsl:value-of select="concat(substring-before(.,'.jpg'),'.tif')"/></note>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 03/26/14: MODS <note> -->
  <xsl:template name="Note">
    <xsl:for-each select="*[starts-with(name(), 'item_-_MODS_-_Notes')]">
      <!-- fcd1, 04/25/14: Do not process an item_-_MODS_-_Notes that -->
      <!-- contains "Original filename", since we are getting the origina -->
      <!-- filename from item_-_OriginalFileLoadedIntoOmeka_ -->
      <!-- fcd1, 07/10/14: add code to make the test case-insensitive -->
      <xsl:variable name="lowercase" select="'aefgilmnor'" />
      <xsl:variable name="uppercase" select="'AEFGILMNOR'" />
      <xsl:if test=" . != ''
		    and
		    not(contains(translate(.,$uppercase,$lowercase),'original filename:'))">
	<note><xsl:value-of select="."/></note>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_AdditionalItemMetadata_-_Provenance')]">
      <xsl:if test=" . != '' ">
	<note type="ownership"><xsl:value-of select="."/></note>
      </xsl:if>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="contains(item_-_OmekaCollection,'Frances Perkins: The Woman Behind the New Deal')">
	<xsl:call-template name="Omeka_OriginalFileLoadedIntoOmeka_normalize_prefix"/>
      </xsl:when>
      <xsl:when test="contains(item_-_OmekaCollection,'George Arthur Plimpton')">
	<xsl:call-template name="Omeka_OriginalFileLoadedIntoOmeka_normalize_prefix"/>
      </xsl:when>
      <xsl:when test="contains(item_-_OmekaCollection,'Sergei Diaghilev and Beyond: Les Ballets Russes')">
	<xsl:call-template name="Omeka_OriginalFileLoadedIntoOmeka_normalize_prefix"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="Omeka_OriginalFileLoadedIntoOmeka"/>
      </xsl:otherwise>
    </xsl:choose>
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
  <!-- fcd1, 08/01/14: Change type attribute for Omeka ID from "local" to "omeka" -->
  <xsl:template name="Identifier">
    <xsl:for-each select="*[starts-with(name(), 'item_-_itemId')]">
      <xsl:if test=" . != '' ">
	<identifier type="omeka"> <xsl:value-of select='concat("omeka_",format-number(., "000000") )' /></identifier>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Identifier')]">
      <xsl:if test=" . != '' ">
	<xsl:if test=" not(starts-with(.,'CLIO_')) ">
	  <xsl:message terminate="yes">
	    ---- !!!! ---- ERROR: Expecting CLIO number in DC Identifier, did not get one! ---- !!!! ----
	    <xsl:text>Value is: </xsl:text><xsl:value-of select="."/>
	    <xsl:text> for Omeka item </xsl:text><xsl:value-of select="../item_-_itemId/."/>
	  </xsl:message>
	</xsl:if>
	<identifier type="CLIO"><xsl:value-of select="."/></identifier>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <typeOfResource> -->
  <!-- use the value in itemType, but make it all lowercase -->
  <!-- fcd1, 05/16/14: CUL specs specify that, if no itemType is given in the metadata, -->
  <!-- then generate one based on the file type of the associated loaded files. THIS IS NOT IMPLEMENTED -->
  <!-- It is probably easier to put in the itemType in the remediated data, based on the file type -->
  <!-- fcd1, 05/27/14: handle case where no item_-_ItemType exists, or it was empty -->
  <!-- Note: to output the complete contents of a variable that may contains a node and children nodes, -->
  <!-- use copy-of, not value-of -->
  <!-- fcd1, 07/01/14: Add code to check if content contains "Original Format:" or -->
  <!-- "Physical Dimensions:". If it does, just use "still image". Reason: the two cases -->
  <!-- are handled in another mapping.-->
  <!-- Frances Perkins: all items contain a populated <item_-_ItemType>, with content either -->
  <!-- "Still Image" or "Document". So here, just lowercase the content and use it in a -->
  <!-- <typeOfResource> -->
  <!-- Melting Pot: most items have an empty <item_-_ItemType>, except for 3 items, with content -->
  <!-- either "original format: photo" or "original format: magazine". My feeling is that these -->
  <!-- should be mapped to a <physicalDescription>, however, will wait for clarification. For now, just -->
  <!-- map to typeOfResource -->
  <xsl:template name="TypeOfResource">
    <xsl:variable name="givenTypeOfResource">
      <xsl:for-each select="*[starts-with(name(), 'item_-_ItemType')]">
	<xsl:if test=" . != '' 
		and
		not(starts-with(., 'Original Format'))
		and
		not(starts-with(., 'Physical Dimensions:'))">
	  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	  <typeOfResource><xsl:value-of select="translate(.,$uppercase,$smallcase)"/></typeOfResource>
	</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$givenTypeOfResource != '' ">
	<xsl:copy-of select="$givenTypeOfResource"/>
      </xsl:when>
      <xsl:otherwise>
	<typeOfResource>still image</typeOfResource>
      </xsl:otherwise>
    </xsl:choose>
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

  <!-- fcd1, 06/25/14: MODS <genre> -->
  <xsl:template name="Genre">
    <xsl:for-each select="*[starts-with(name(), 'item_-_DublinCore_-_Type')]">
      <xsl:if test=" . != '' ">
	<genre><xsl:value-of select="."/></genre>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- fcd1, 04/23/14: MODS <physicalLocation type="code"> -->
  <!-- fcd1, 03/24/14: Assumes metadata being process has been remediated and contains correct and valid code -->
  <!-- fcd1, 07/08/14: since the Non-CUl repository code is an internal CUL code, do not include -->
  <!-- the authority attribute in that case -->
  <xsl:template match="item_-_MODS_-_RepositoryName_-_code">
    <xsl:if test=" . != '' ">
      <xsl:choose>
	<xsl:when test=". = 'Non-CUL' ">
	  <physicalLocation>
	    <xsl:value-of select="."/>
	  </physicalLocation>
	</xsl:when>
	<xsl:otherwise>
	  <physicalLocation authority="marcorg">
	    <xsl:value-of select="."/>
	  </physicalLocation>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="GeorgePlimptonSpecific">
    <xsl:for-each select="Plimpton_item_-_ItemType_1">
      <xsl:if test=" . != '' ">
	<form><xsl:value-of select="substring-after(.,'Original Format: ')"/></form>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="Plimpton_item_-_ItemType_2">
      <xsl:if test=" . != '' ">
	<extent><xsl:value-of select="substring-after(.,'Physical Dimensions: ')"/></extent>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
