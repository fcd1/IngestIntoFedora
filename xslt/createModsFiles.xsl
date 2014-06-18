<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
		xmlns="http://www.loc.gov/mods/v3"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xpath-default-namespace="http://www.loc.gov/mods/v3">
  <xsl:output method="xml" indent = "yes" encoding="UTF-8"/>
    <xsl:template match="mods">
      <xsl:variable name="filename" select="concat(identifier/.,'.xml')"/>
      <xsl:result-document method="xml" href="{$filename}" encoding="UTF-8" indent="yes">
	<xsl:copy>
	  <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd</xsl:attribute>
	  <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
	  <xsl:copy-of select="./*"/>
	</xsl:copy>
      </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
