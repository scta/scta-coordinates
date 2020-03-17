<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:new="http://new"
  xmlns:transk="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
  xmlns:ns3="http://www.loc.gov/METS/"
  xmlns:ns2="http://www.w3.org/1999/xlink"
  xpath-default-namespace="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
  exclude-result-prefixes="xs"
  version="2.0"
  >
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="pagepath">../Basel1586/page/</xsl:param>
  <xsl:param name="colums">2</xsl:param>
  <xsl:template match="/">
    <xsl:message>Test1</xsl:message>
    <div>
      <p>
        <xsl:for-each select="collection(concat($pagepath, '?select=*.xml'))">
          <xsl:variable name="column">
            <xsl:message><xsl:value-of select="count(//transk:TextRegion)"/></xsl:message>
            <xsl:message>Position <xsl:value-of select="position()"/></xsl:message>
            <xsl:choose>
              <xsl:when test="count(//transk:TextRegion) gt 1">
                <xsl:choose>
                  <xsl:when test="position() eq 1">a</xsl:when>
                  <xsl:when test="position() eq 2">b</xsl:when>
                  <xsl:when test="position() eq 3">c</xsl:when>
                  <xsl:otherwise>a</xsl:otherwise>
                </xsl:choose>
                
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="folioAndSide" select="substring-before(., '.xml')"/>
          <xsl:variable name="folio" select="replace($folioAndSide, '([rv])', '')"/>
          <xsl:variable name="side" select="replace($folioAndSide, '([0-9])', '')"/>
          <pb ed="#U" n="{concat($folio, '-', $side)}"/>
          
          <xsl:if test="$column">
          <cb ed="#B" n="{$column}"/>
          </xsl:if>
          <xsl:call-template name="getText">
            <xsl:with-param name="pageLine" select=".//transk:TextLine"/>
            <xsl:with-param name="pageNo" select="."/>
          </xsl:call-template>  
      </xsl:for-each>
      
      </p>
    </div>
  </xsl:template>
  
  <xsl:template name="getText">
    <xsl:param name="pageLine"/>
    <xsl:param name="pageNo"/>
    <xsl:for-each select="$pageLine">
      <xsl:variable name="page" select="$pageNo"/>
      <xsl:variable name="id" select="./@id"/>
      <xsl:variable name="number" select="tokenize(./@custom, ':')[2]"/>
      <xsl:variable name="position" select="count(.//preceding-sibling::transk:TextLine) + 1"/>
      <lb ed="#B1" n="{$position}"/><xsl:value-of select="./TextEquiv/Unicode"/><xsl:text> 
      </xsl:text>
      
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>