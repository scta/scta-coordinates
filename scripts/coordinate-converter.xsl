<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:new="http://new"
  xpath-default-namespace="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
  exclude-result-prefixes="xs"
  version="2.0">
  <xsl:output method="text"/>
  <xsl:param name="colums">2</xsl:param>
  <xsl:template match="/">[<xsl:call-template name="coordinate-extraction"/>
]</xsl:template>
  
  <xsl:template name="coordinate-extraction">
    <xsl:for-each select="//TextRegion[@id='r1']//TextLine | //TextRegion[@id='r2']//TextLine">
      <xsl:variable name="lineId" select="./@id"/>
      <xsl:variable name="coords" select="tokenize(./Coords/@points, ' ')"/>
      <xsl:variable name="coordsAmount" select="count($coords)"/>
      <xsl:variable name="coordsMid" select="$coordsAmount div 2"/>

      <xsl:variable name="yBottomValues">
        <xsl:for-each select="$coords">
          <xsl:if test="position() &lt;= $coordsMid">
          <y xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[2]"/></y>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="yBottomMax">
        <xsl:value-of select="max($yBottomValues//new:y)"/>
      </xsl:variable>
      <xsl:variable name="yTopValues">
        <xsl:for-each select="$coords">
          <xsl:if test="position() &gt; $coordsMid">
            <y xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[2]"/></y>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="yTopMin">
        <xsl:value-of select="min($yTopValues//new:y)"/>
      </xsl:variable>
      
      <xsl:message>-</xsl:message>
      <xsl:message select="$yBottomMax"></xsl:message>
      <xsl:message>-</xsl:message>
      <xsl:message select="$yTopMin"></xsl:message>
      <xsl:message>-</xsl:message>
      <xsl:variable name="bottomLeft" select="$coords[1]"/>
      <xsl:variable name="bottomRight" select="$coords[$coordsMid]"/>
      <xsl:variable name="topRight" select="$coords[$coordsMid + 1]"/>
      <xsl:variable name="topLeft" select="$coords[$coordsAmount]"/>
      <xsl:variable name="topLeftX" select="tokenize($topLeft, ',')[1]"/>
      <xsl:variable name="topRightX" select="tokenize($topRight, ',')[1]"/>
      <xsl:variable name="topLeftY" select="tokenize($topLeft, ',')[2]"/>
      <xsl:variable name="bottomLeftY" select="tokenize($bottomLeft, ',')[2]"/>
      <xsl:variable name="width" select="number($topRightX) - number($topLeftX)"/>
<xsl:variable name="height" select="number($yBottomMax) - number($yTopMin)"/>
  {
    "amount": <xsl:value-of select="$coordsAmount"/>,
    "id":"<xsl:value-of select="$lineId"/>",
    "bottom-left": "<xsl:value-of select="$bottomLeft"/>",
    "bottom-right": "<xsl:value-of select="$bottomRight"/>",
    "top-right": "<xsl:value-of select="$topRight"/>",
    "top-left": "<xsl:value-of select="$topLeft"/>",
    "width": "<xsl:value-of select="$width"/>",
    "height": "<xsl:value-of select="$height"/>",
    "iiif": "<xsl:value-of select="concat($topLeftX, ',', $yTopMin, ',', $width, ',', $height)"/>",
    "iiif-adjusted": "<xsl:value-of select="concat(number($topLeftX) - 35, ',', number($yTopMin) - 20, ',', $width + 65, ',', $height + 40)"/>"
  }<xsl:if test="position() != last()" >,</xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>