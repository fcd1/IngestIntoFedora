<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xpath-default-namespace="http://www.loc.gov/mods/v3">
  <xsl:output method="text" indent = "no" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/modsCollection">
    <xsl:for-each select="mods/identifier">
      <xsl:sort select="."/>
      <xsl:call-template name="identifier"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="identifier">
    <xsl:if test="@type='local'">
      <xsl:value-of select="concat(.,'.xml')"/>
      <xsl:text>,</xsl:text>
      <xsl:choose>
	<xsl:when test="position() = last()">
	  <xsl:apply-templates select="../note">
	    <xsl:with-param name="endofline">
	    </xsl:with-param>
	  </xsl:apply-templates>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="../note">
	    <xsl:with-param name="endofline">
	      <xsl:text>&#10;</xsl:text>
	    </xsl:with-param>
	  </xsl:apply-templates>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="note">
    <xsl:param name="endofline"/>
    <xsl:if test="starts-with(.,'original filename')">
      <xsl:value-of select="replace(.,'original filename: ','')"/>
      <xsl:choose>
	<xsl:when test="position() = last()">
	  <xsl:value-of select="$endofline"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text> </xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
