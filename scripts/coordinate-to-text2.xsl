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
  <xsl:param name="pagepath">../cod-u78xZZ/cod-u78xZZ/page/</xsl:param>
  <xsl:param name="colums">2</xsl:param>
  <xsl:template match="/">
    <xsl:message>Test1</xsl:message>
    <div>
      <p>
      <xsl:for-each select="ns3:mets/ns3:fileSec[1]/ns3:fileGrp[1]/ns3:fileGrp[1]//ns3:file/ns3:FLocat[1]/@ns2:href">
        <xsl:variable name="fileName" select="tokenize(., '/')[2]"/>
        <xsl:for-each select="document(concat($pagepath, $fileName))//transk:TextRegion">
          
          <xsl:comment>
            <xsl:value-of select="$fileName"/>
          </xsl:comment>
      <xsl:text>
      </xsl:text>
          <xsl:variable name="column">
            <xsl:message><xsl:value-of select="count(//transk:TextRegion)"/></xsl:message>
            <xsl:message>Position <xsl:value-of select="position()"/></xsl:message>
            <xsl:choose>
              <xsl:when test="count(//transk:TextRegion) gt 1">
                <xsl:choose>
                  <xsl:when test="position() eq 1">a</xsl:when>
                  <xsl:when test="position() eq 2">b</xsl:when>
                  <xsl:when test="position() eq 3">c</xsl:when>
                  <xsl:when test="position() eq 3">d</xsl:when>
                  <xsl:when test="position() eq 3">e</xsl:when>
                  <xsl:otherwise>a</xsl:otherwise>
                </xsl:choose>
                
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="folioAndSide" select="substring-before($fileName, '.xml')"/>
          <xsl:variable name="folio" select="replace($folioAndSide, '([rv])', '')"/>
          <xsl:variable name="side" select="replace($folioAndSide, '([0-9])', '')"/>
          <!--<xsl:if test="$column != 'b'">
          <pb ed="#S" n="{concat($folio, '-', $side)}"/>
          </xsl:if>-->
          <xsl:if test="$column != 'b'">
            <pb ed="#V" n="{$folio}"/>
          </xsl:if>
          <!--<pb ed="#P" n="{$folio}"/>-->
          
          <xsl:if test="$column">
            <cb ed="#V" n="{$column}"/>
          </xsl:if>
          <xsl:call-template name="getText">
            <xsl:with-param name="pageLine" select=".//transk:TextLine"/>
            <xsl:with-param name="pageNo" select="$fileName"/>
          </xsl:call-template>  
      </xsl:for-each>
      
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
      <xsl:variable name="position" select="count(.//preceding::transk:TextLine) + 1"/>
      <lb ed="#V" n="{$position}"/><xsl:value-of select="./TextEquiv/Unicode"/><xsl:text> 
      </xsl:text>
      
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>