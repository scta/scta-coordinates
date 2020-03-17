<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0" xmlns:lines="http://scta.info/ns/xml-lines" xmlns:transk="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15">
  <xsl:output method="text" omit-xml-declaration="yes"/>
  <xsl:param name="fileName"></xsl:param>
  <xsl:param name="codexName"></xsl:param>
  
  <xsl:template match="/">
    
    <xsl:variable name="lineDoc" select="document(concat('../', $codexName, '/lineText/', $fileName, '.xml'))"></xsl:variable>
    <xsl:variable name="coordDoc" select="document(concat('../', $codexName, '/page/' , $fileName, '.xml'))"></xsl:variable>
    <xsl:variable name="lineCount" select="count($lineDoc//lines:line)"></xsl:variable>
    <xsl:variable name="coordCount" select="count($coordDoc//transk:TextLine)"></xsl:variable>
    <xsl:if test="$lineCount != $coordCount">
      <xsl:text> 
      </xsl:text>
      <xsl:value-of select="concat($codexName, '/page/' , $fileName, '.xml')"/>
      <xsl:message><xsl:value-of select="concat($codexName, '/page/' , $fileName, '.xml')"/></xsl:message>
      <xsl:text> 
      </xsl:text>
      <xsl:value-of select="$lineCount"/>
      <xsl:message><xsl:value-of select="$lineCount"/></xsl:message>
      <xsl:text> 
      </xsl:text>
      <xsl:value-of select="$coordCount"/>
      <xsl:message><xsl:value-of select="$coordCount"/></xsl:message>
      <xsl:text> 
      </xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>