<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:new="http://new"
  xmlns:sctaln="http://scta.info/ns/xml-lines"
  xmlns:sctac="http://scta.info/ns/codices"
  xmlns:transk="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
  xmlns:sctacim='http://scta.info/ns/canvas-image-map'
  exclude-result-prefixes="xs"
  version="2.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="colums">2</xsl:param>
  <xsl:param name="codexid">vatlat955</xsl:param>
  <!-- a parameter to determine where widht is retrieved from (the "column" or "line") -->
  <xsl:param name="widthStandard">column</xsl:param>
  <!--<xsl:param name="initial">L</xsl:param>-->
  <xsl:template match="/">
    
    <lines xmlns="http://new" >
      
      <xsl:call-template name="coordinate-extraction">
      
      </xsl:call-template>
    </lines>
  </xsl:template>
  
  <xsl:template name="coordinate-extraction">
    <xsl:variable name="pageOrderNumber" select="/transk:PcGts/transk:Metadata[1]/transk:TranskribusMetadata[1]/@pageNr"/>
    
    <xsl:variable name="textFileName" select="substring-after(base-uri(), concat('file:/Users/jcwitt/Projects/scta/scta-coordinates/', $codexid, '/page/'))"/>
    <xsl:variable name="surfaceIdSlug" select=" substring-before($textFileName, '.xml')"/>
    <xsl:variable name="surfaceDoc" select="document(concat('file:/Users/jcwitt/Projects/scta/scta-codices/', $codexid, '.xml'))"/>
    <xsl:variable name="canvasBase" select="$surfaceDoc//canvasBase[1]"/>
    <xsl:variable name="canvasIdSlug"><xsl:value-of select="$surfaceDoc//codex/surfaces/surface[shortid = concat($codexid, '/', $surfaceIdSlug)]/hasISurfaces/ISurface/canvasslug"/></xsl:variable>
    <xsl:variable name="canvasId"><xsl:value-of select="concat($canvasBase, $canvasIdSlug)"/></xsl:variable>
    <xsl:variable name="imageCanvasMapDoc" select="document(concat('file:/Users/jcwitt/Projects/scta/scta-coordinates/', $codexid, '/imageCanvasMap.xml'))"/>
    <xsl:variable name="imageUrl" select="$imageCanvasMapDoc//sctacim:pair[sctacim:canvas/text() = $canvasId]/sctacim:image"/>
    <xsl:variable name="surfaceId" select="$imageCanvasMapDoc//sctacim:pair[sctacim:canvas/text() = $canvasId]/sctacim:surfaceId"/>
    <xsl:variable name="textDoc" select="document(concat('../', $codexid, '/lineText/', $textFileName))"/>
    <xsl:for-each select="//transk:TextRegion//transk:TextLine ">
      <xsl:variable name="textRegionCoords" select="tokenize(./parent::transk:TextRegion/transk:Coords/@points, ' ')"/>
      
      <xsl:variable name="columnXValues">
        <xsl:for-each select="$textRegionCoords">
          <x xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[1]"/></x>
        </xsl:for-each>
      </xsl:variable>
      
      <xsl:variable name="columnX1">
        <xsl:value-of select="min($columnXValues//new:x)"/>
      </xsl:variable>
      <xsl:variable name="columnX2">
        <xsl:value-of select="max($columnXValues//new:x)"/>
      </xsl:variable>
      
      
      <!--<xsl:variable name="columnX1" select="tokenize($textRegionCoords[1], ',')[1]"/>-->
      <xsl:message>column x1 <xsl:value-of select="$columnX1"/></xsl:message>
      <!-- coordinate order is not always the same, so $textRegionCoords index may need to be switched from 3 to 2 or 2 to 3 -->
      <!--<xsl:variable name="columnX2" select="tokenize($textRegionCoords[3], ',')[1]"/>-->
      <xsl:message>column x2 <xsl:value-of select="$columnX2"/></xsl:message>
      <xsl:variable name="columnWidth" select="number($columnX2) - number($columnX1)"/>
      
      <xsl:variable name="lineNumber" select="position()"/>
      <xsl:variable name="text" select="$textDoc/sctaln:div/sctaln:line[position() = $lineNumber]"/>
      <xsl:variable name="lineId" select="./@id"/>
      <xsl:variable name="coords" select="tokenize(./transk:Coords/@points, ' ')"/>
      <xsl:variable name="coordsAmount" select="count($coords)"/>
      <xsl:variable name="coordsMid" select="$coordsAmount div 2"/>
      <!-- sometimes the coordinates start with the top line and sometimes with this bottom
        this variable is needed to check the order 
        if the top line comes first then the first y coordinates will be less then the last y coordinate 
        the variable is used in the conditions below
      -->
      <xsl:variable name="topFirstCheck" select="number(tokenize($coords[1], ',')[2]) &lt;= number(tokenize($coords[$coordsAmount], ',')[2])"/>
      
      
      <xsl:variable name="yBottomValues">
        
          <xsl:for-each select="$coords">
            <xsl:choose>
              <!-- this conditional appears necessary, because manual lines 
              appear to have a reverse order namely Tops first then Bottoms -->
              <xsl:when test="$topFirstCheck">
                <xsl:if test="position() &gt;= $coordsMid">
                  <y xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[2]"/></y>
                </xsl:if>
              </xsl:when>
              <!-- automated lines appeare to have bottoms first and then tops -->
              <xsl:otherwise>
                <xsl:if test="position() &lt;= $coordsMid">
                  <y xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[2]"/></y>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="yBottomMax">
        <xsl:value-of select="max($yBottomValues//new:y)"/>
      </xsl:variable>
      <xsl:variable name="yTopValues">
        <xsl:for-each select="$coords">
          <xsl:choose>
            <!-- this conditional appears necessary, because manual lines 
              appear to have a reverse order namely Tops first then Bottoms -->
            <xsl:when test="$topFirstCheck">
              <xsl:if test="position() &lt;= $coordsMid">
                <y xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[2]"/></y>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <!-- automated lines appeare to have bottoms first and then tops -->
              <xsl:if test="position() &gt; $coordsMid">
                <y xmlns="http://new" id="{position()}"><xsl:value-of select="tokenize(., ',')[2]"/></y>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="yTopMin">
        <xsl:value-of select="min($yTopValues//new:y)"/>
      </xsl:variable>
      <xsl:variable name="column">
        <xsl:choose>
          <xsl:when test="count(./parent::transk:TextRegion/preceding-sibling::transk:TextRegion) eq 0">a</xsl:when>
          <xsl:when test="count(./parent::transk:TextRegion/preceding-sibling::transk:TextRegion) eq 1">b</xsl:when>
          <xsl:when test="count(./parent::transk:TextRegion/preceding-sibling::transk:TextRegion) eq 2">c</xsl:when>
          <xsl:when test="count(./parent::transk:TextRegion/preceding-sibling::transk:TextRegion) eq 3">d</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="bottomLeft" select="$coords[1]"/>
      <xsl:variable name="bottomRight" select="$coords[$coordsMid]"/>
      <xsl:variable name="topRight" select="$coords[$coordsMid + 1]"/>
      <xsl:variable name="topLeft" select="$coords[$coordsAmount]"/>
      <xsl:variable name="topLeftX">
        <xsl:choose>
          <xsl:when test="$widthStandard eq 'column'">
            <xsl:value-of select="$columnX1"/>
          </xsl:when>
          <xsl:when test="$widthStandard eq 'line'">
            <xsl:message>Using lines: <xsl:value-of select="tokenize($topLeft, ',')[1]"/></xsl:message>
            <xsl:value-of select="tokenize($topLeft, ',')[1]"/>
            
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="tokenize($topLeft, ',')[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="topRightX" select="tokenize($topRight, ',')[1]"/>
      <xsl:variable name="topLeftY" select="tokenize($topLeft, ',')[2]"/>
      <xsl:variable name="bottomLeftY" select="tokenize($bottomLeft, ',')[2]"/>
      <xsl:variable name="width">
        <xsl:choose>
          <xsl:when test="$widthStandard eq 'column'">
            <xsl:message>Column width: <xsl:value-of select="$columnWidth"/></xsl:message>
            <xsl:value-of select="$columnWidth"/>
          </xsl:when>
          <xsl:when test="$widthStandard eq 'line'">
            <xsl:value-of select="number($topRightX) - number($topLeftX)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="number($topRightX) - number($topLeftX)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable> 
<xsl:variable name="height" select="number($yBottomMax) - number($yTopMin)"/>
      <line xmlns="http://new">
    <pageOrderNumber><xsl:value-of select="$pageOrderNumber"/></pageOrderNumber>
    <amount><xsl:value-of select="$coordsAmount"/></amount>
    <id><xsl:value-of select="$lineId"/></id>
    <column><xsl:value-of select="$column"/></column>
    <surfaceIdSlug><xsl:value-of select="$surfaceIdSlug"/></surfaceIdSlug>
    <canvasId><xsl:value-of select="$canvasId"/></canvasId>
    <imageUrl><xsl:value-of select="$imageUrl"/></imageUrl>
    <surfaceId><xsl:value-of select="$surfaceId"/></surfaceId>
    <lineNumber><xsl:value-of select="$lineNumber"/></lineNumber>
    <bottomLeft><xsl:value-of select="$bottomLeft"/></bottomLeft>
    <bottomRight><xsl:value-of select="$bottomRight"/></bottomRight>
    <topRight><xsl:value-of select="$topRight"/></topRight>
    <topLeft><xsl:value-of select="$topLeft"/></topLeft>
    <width><xsl:value-of select="$width"/></width>
    <height><xsl:value-of select="$height"/></height>
    <iiif><xsl:value-of select="concat($topLeftX, ',', $yTopMin, ',', $width, ',', $height)"/></iiif>
     <!-- created adjusted variables; but perform checks to make sure value is never less than 0 -->
    <xsl:variable name="adjustedTopLeftX" select="if (number($topLeftX) gt 35) then (number($topLeftX) - 35) else $topLeftX"/>
    <xsl:variable name="adjustedYTopMin" select="if (number($yTopMin) gt 20) then (number($yTopMin) - 20) else $yTopMin"/>
        <!-- TODO; checks might also be necessary to make sure width and height values do not go beyond height/width of image 
          though this seems like an unusual case  -->
    <iiifAdjusted><xsl:value-of select="concat($adjustedTopLeftX, ',', $adjustedYTopMin, ',', $width + 65, ',', $height + 40)"/></iiifAdjusted>
    <text><xsl:value-of select="$text"/></text>
        <!--<text><xsl:call-template name="word">
        <xsl:with-param name="lineText" select="$text"></xsl:with-param>
        </xsl:call-template></text>-->
  </line>
    </xsl:for-each>
  </xsl:template>
  <!-- TODOuncomment to keep word wrap and add word coordinates when they are available -->
  <xsl:template name="word">
    <xsl:param name="lineText"/>
    <xsl:for-each select="$lineText//sctaln:word">
      <word xmlns="http://new" n="{./@n}">
      <xsl:value-of select="."/>
    </word>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>