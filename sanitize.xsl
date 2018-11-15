<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html">

  <xsl:output
      method="xml"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
      version="1.0"
      indent="yes"
      omit-xml-declaration="yes"
      encoding="utf-8"/>

  <xsl:variable name="nl" select="'&#xa;'" />

  <xsl:template match="@*[local-name()!='xmlns']">
    <xsl:variable name="name" select="local-name()" />
    <xsl:variable name="val" select="." />
    <xsl:attribute name="{$name}">
      <xsl:value-of select="$val" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:comment><xsl:value-of select="." /></xsl:comment>
  </xsl:template>

  <xsl:template match="text()"><xsl:value-of select="." /></xsl:template>

  <xsl:template match="processing-instruction()">
    <xsl:variable name="name" select="local-name()" />
    <xsl:processing-instruction name="{$name}"><xsl:value-of select="." /></xsl:processing-instruction>
  </xsl:template>

  <xsl:template match="*">
    <xsl:variable name="name" select="local-name()" />
    <xsl:element name="{$name}">
      <xsl:apply-templates select="./attribute::node()[not(@xmlns)]" />
      <xsl:apply-templates select="./child::node()" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
