<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent = "yes" />
  <xsl:template match="/">
    <RemoveMeEXCLEMATIONPOINT>
      <xsl:apply-templates select="itemContainer" />
    </RemoveMeEXCLEMATIONPOINT>
  </xsl:template>
      
  <xsl:template match="itemContainer">
    <xsl:apply-templates select="item"/>
  </xsl:template> 
  
  <xsl:template match="item">
    <xsl:variable name="varItemID" select="@itemId" />
    <xsl:apply-templates select="ItemInContext" />
  </xsl:template>
  
  <xsl:template match="ItemInContext">
    <ItemInContext>
      <xsl:attribute name="itemID"><xsl:value-of select="../@itemId"/></xsl:attribute>
      <xsl:value-of select="."/>
    </ItemInContext>
  </xsl:template>

</xsl:stylesheet>
