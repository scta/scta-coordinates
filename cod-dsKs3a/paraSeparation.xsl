<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:template match="/">
    
    <xsl:for-each select="//p[contains(@alias, '-i-')]">
      <xsl:copy-of select=".">
      </xsl:copy-of>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
