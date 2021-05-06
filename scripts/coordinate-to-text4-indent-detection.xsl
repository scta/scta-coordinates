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
  <xsl:param name="pagepath">../cod-MkL9py_728/cod-MkL9py_728/page/</xsl:param>
  <xsl:param name="colums">2</xsl:param>
  <xsl:template match="/">
    <xsl:message>Test1</xsl:message>
    <div>
      <p>
      <xsl:for-each select="ns3:mets/ns3:fileSec[1]/ns3:fileGrp[1]/ns3:fileGrp[1]//ns3:file/ns3:FLocat[1]/@ns2:href">
        <xsl:variable name="fileName" select="tokenize(., '/')[2]"/>
        <xsl:message>TEST</xsl:message>
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
                  <xsl:otherwise>a</xsl:otherwise>
                </xsl:choose>
                
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="folioAndSide" select="substring-before($fileName, '.xml')"/>
          <xsl:variable name="folio" select="replace($folioAndSide, '([rv])', '')"/>
          <xsl:variable name="side" select="replace($folioAndSide, '([0-9])', '')"/>
          <xsl:if test="$column != 'b'">
          <pb ed="#H" n="{$folio}"/>
          </xsl:if>
          <!--<xsl:if test="$column eq 'a'">
            <pb ed="#J" n="{$folio}"/>
          </xsl:if>-->
          
          <xsl:if test="$column">
            <cb ed="#H" n="{$column}"/>
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
      
      <xsl:variable name="curentMinX">
        <xsl:call-template name="getMinXValue">
          <xsl:with-param name="coords" select="tokenize(./Coords/@points, ' ')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="previousMinX">
        <xsl:call-template name="getMinXValue">
          <xsl:with-param name="coords" select="tokenize(./preceding-sibling::TextLine[1]/Coords/@points, ' ')"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="difference" select="$curentMinX - $previousMinX"/>
      
      
      <xsl:if test="$difference > 20">[indent]</xsl:if><lb ed="#H" n="{$position}"/><xsl:value-of select="./TextEquiv/Unicode"/><xsl:text> 
      </xsl:text>
      
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="getMinXValue">
    <xsl:param name="coords"/>
    <xsl:variable name="XValues">
      <xsl:for-each select="$coords">
        <x xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[1]"/></x>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="leftX">
      <xsl:value-of select="min($XValues//new:x)"/>
    </xsl:variable>
    <xsl:value-of select="number($leftX[1])"/>
  
  </xsl:template>
</xsl:stylesheet>