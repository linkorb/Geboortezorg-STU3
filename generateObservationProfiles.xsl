<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://hl7.org/fhir"
    exclude-result-prefixes="xsl xs xd f"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Dec 24, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> lminne</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output omit-xml-declaration="yes"/>
    
    <!-- input: data items waarvoor profiel gemaakt moet worden -->
    <xsl:variable name="dataItems" as="element()*">
        <item>
            <id>peri23-dataelement-80625</id>
            <translation>Pregnancy-EndType</translation>
            <datatype>Code</datatype>
            <focus>Zwangerschap</focus>
        </item>
        <item>
            <id>peri23-dataelement-20540</id>
            <translation>Pregnancy-EndDate</translation>
            <datatype>Datum/tijd</datatype>
            <focus>Zwangerschap</focus>
        </item>
        <item>
            <id>peri23-dataelement-20550</id>
            <translation>Birth-StartType</translation>
            <datatype>Code</datatype>
            <focus>Bevallingsfase</focus>
        </item>
        <item>
            <id>peri23-dataelement-20630</id>
            <translation>BirthPlacenta</translation>
            <datatype>Code</datatype>
            <focus>Bevallingsfase</focus>
        </item>
        <item>
            <id>peri23-dataelement-20640</id>
            <translation>BloodLoss</translation>
            <datatype>Hoeveelheid</datatype>
            <focus>Bevallingsfase</focus>
        </item>        		
        <item>
            <id>peri23-dataelement-80673</id>
            <translation>StatePerineumPostpartum</translation>
            <datatype>Code</datatype>
            <focus>Bevallingsfase</focus>
        </item> 
        <item>
            <id>peri23-dataelement-80705</id>
            <translation>PerinatalDeath</translation>
            <datatype>Boolean</datatype>
            <focus>Bevallingsfase</focus>
            <focuschild value="true"/>
        </item>
        <item>
            <id>peri23-dataelement-40290</id>
            <translation>PerinatalDeath-Phase</translation>
            <datatype>Code</datatype>
            <focus>Uitdrijvingsfase</focus>
            <focuschild value="true"/>
        </item> 
        <item>
            <id>peri23-dataelement-80626</id>
            <translation>ParturitionType</translation>
            <datatype>Code</datatype>
            <focus>Bevallingsfase</focus>
            <focuschild value="true"/>
        </item> 
        <item>
            <id>peri23-dataelement-20590</id>
            <translation>OnsetOfLaborFirstStage</translation>
            <datatype>Datum/tijd</datatype>
            <focus>Bevallingsfase</focus>
        </item>
        <item>
            <id>peri23-dataelement-30030</id>
            <translation>OnsetOfPushing</translation>
            <datatype>Datum/tijd</datatype>
            <focus>Bevallingsfase</focus>
        </item>        
    </xsl:variable>
    
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    
    <!-- input: url dataset op decor -->
    <xsl:param name="url" select=
        "document('http://decor.nictiz.nl/decor/services/RetrieveTransaction?language=nl-NL&amp;version=2019-09-26T16%3A35%3A41&amp;id=2.16.840.1.113883.2.4.3.11.60.90.77.1.6&amp;format=xml')"/>
    
    <!-- voor alle input data items: opzoeken op decor & structuredefinition aanmaken -->    
    <xsl:template match="/">
        <xsl:variable name="count" select="count($dataItems)"/>
        <xsl:for-each select="(//*)[position()&lt;=$count]">
            <xsl:variable name="pos" select="position()"/>
            <xsl:variable name="id" select="$dataItems[$pos]/id"/>
            <xsl:variable name="translation" select="$dataItems[$pos]/translation"/>
            <xsl:variable name="dataType" select="$dataItems[$pos]/datatype"/>
            <xsl:variable name="focus" select="lower-case($dataItems[$pos]/focus)"/>
            <xsl:variable name="focusChild" select="$dataItems[$pos]/focuschild"/>
            
            <xsl:value-of select="$id"/>
            <xsl:text>&#xa;</xsl:text>
            
            <xsl:for-each select="$url//*[matches(@iddisplay,$dataItems[$pos]/id)]">
                <xsl:variable name="conceptIdDisplay" select="@iddisplay"/>
                <xsl:variable name="conceptName" select="./name"/>
                <xsl:variable name="conceptId" select="./inherit/@ref|./@id[1]"/>
                <xsl:variable name="terminology" select="./terminologyAssociation[@conceptId=$conceptId]"/>
                <xsl:variable name="concept" select="$terminology[@codeSystemName='SNOMED CT']|$terminology[@codeSystemName='LOINC']|$terminology[1]"/>
                <xsl:variable name="conceptCode" select="./terminologyAssociation[@conceptId=$conceptId]/@code"/>
                <xsl:variable name="conceptDisplay" select="./terminologyAssociation[@conceptId=$conceptId]/@displayName"/>
                <xsl:variable name="conceptCodeSystem" select="./terminologyAssociation[@conceptId=$conceptId]/@codeSystem"/>
                <xsl:variable name="valueSetID" select="./valueSet/@id"/>
                <xsl:variable name="valueSetName" select="./valueSet/@displayName"/>
                <xsl:variable name="effective" select="translate(./valueSet/@effectiveDate,'-T:','')"/>
                                        
                <xsl:result-document href="{concat('bc-',translate($translation, ' ', ''),'.xml')}" indent="yes" method="xml" omit-xml-declaration="yes"> 
                    
                    <!-- XML StructureDefinition -->
                    <xsl:comment>This example is autogenerated by https://github.com/Nictiz/Geboortezorg-STU3/blob/master/generateObservationProfiles.xsl</xsl:comment>
                    <xsl:text>&#xa;</xsl:text>
                    <StructureDefinition xmlns="http://hl7.org/fhir">
                        <url value="http://nictiz.nl/fhir/StructureDefinition/bc-{translate($translation, ' ', '')}"/>
                        <name value="bc-{translate($translation, ' ', '')}"/>
                        <status value="draft"/>
                        <fhirVersion value="3.0.1"/>
                        <mapping>
                            <identity value="hcim-basicelements-v1.0-2017EN"/>
                            <uri value="https://zibs.nl/wiki/BasicElements-v1.0(2017EN)"/>
                            <name value="HCIM BasicElements-v1.0(2017EN)"/>
                        </mapping>
                        <mapping>
                            <identity value="gebz-peri-v2.3" />
                            <uri value="https://decor.nictiz.nl/art-decor/decor-datasets--peri20-?id=2.16.840.1.113883.2.4.3.11.60.90.77.1.6&amp;effectiveDate=2016-09-08T00%3A00%3A00&amp;conceptId=2.16.840.1.113883.2.4.3.11.60.90.77.2.6.40050&amp;conceptEffectiveDate=2016-09-08T00%3A00%3A00" />
                            <name value="Geboortezorg Perinatologie 2.3" />
                        </mapping>
                        <kind value="resource"/>
                        <abstract value="false"/>
                        <type value="Observation"/>
                        <baseDefinition value="http://fhir.nl/fhir/StructureDefinition/nl-core-observation"/>
                        <derivation value="constraint"/>
                        
                        <!-- differential -->                        
                        <differential>
                            <!-- eoc extensie -->
                            <element id="Observation.extension">
                                <path value="Observation.extension"/>
                                <slicing>
                                    <discriminator>
                                        <type value="value"/>
                                        <path value="url"/>
                                    </discriminator>
                                    <rules value="open"/>
                                </slicing>
                            </element>
                                                        
                            <!-- focus extensie afhankelijk van zwangerschap/bevallingsfase -->
                            <xsl:choose>
                                <xsl:when test="$focus!=''">
                                    <element id="Observation.extension:{$focus}">
                                        <path value="Observation.extension"/>
                                        <sliceName value="{$focus}"/>
                                        <type>
                                            <code value="Extension"/>
                                            <profile value="http://nictiz.nl/fhir/StructureDefinition/Observation-focus-stu3"/>
                                        </type>
                                    </element>
                                    <element id="Observation.extension:{$focus}.valueReference:valueReference">
                                        <path value="Observation.extension.valueReference"/>
                                        <sliceName value="valueReference"/>
                                        <type>
                                            <code value="Reference"/>
                                            <xsl:choose>
                                                <xsl:when test="$focus='zwangerschap'">
                                                    <targetProfile value="http://nictiz.nl/fhir/StructureDefinition/bc-Pregnancy"/>
                                                </xsl:when>
                                                <xsl:when test="$focus='bevallingsfase'">
                                                    <targetProfile value="http://nictiz.nl/fhir/StructureDefinition/bc-Delivery-StageOfLabor"/>
                                                </xsl:when>
                                            </xsl:choose>  
                                        </type>
                                    </element>
                                </xsl:when>
                            </xsl:choose>
                            
                            <!-- focus extensie voor kindspecifieke uitkomstgegevens bij bevalling -->
                            <xsl:choose>
                                <xsl:when test="$focusChild">
                                    <element id="Observation.extension:focusChild">
                                        <path value="Observation.extension" />
                                        <sliceName value="focusChild" />
                                        <type>
                                            <code value="Extension" />
                                            <profile value="http://nictiz.nl/fhir/StructureDefinition/Observation-focus-stu3" />
                                        </type>
                                    </element>
                                    <element id="Observation.extension:focusChild.valueReference:valueReference">
                                        <path value="Observation.extension.valueReference" />
                                        <sliceName value="valueReference" />
                                        <type>
                                            <code value="Reference" />
                                            <targetProfile value="http://nictiz.nl/fhir/StructureDefinition/StructureDefinition/bc-Fetus" />
                                        </type>
                                        <type>
                                            <code value="Reference" />
                                            <targetProfile value="http://nictiz.nl/fhir/StructureDefinition/StructureDefinition/bc-Child" />
                                        </type>
                                    </element>
                                </xsl:when>
                            </xsl:choose>
                            
                            <!-- SNOMED codering voor observatie (concept) -->
                            <xsl:choose>
                                <xsl:when test="$conceptCode!=''">
                                    <element id="Observation.code.coding">
                                        <path value="Observation.code.coding"/>
                                        <slicing>
                                            <discriminator>
                                                <type value="value"/>
                                                <path value="code"/>
                                            </discriminator>
                                            <rules value="open"/>
                                        </slicing>
                                    </element>
                                    <element id="Observation.code.coding:{$conceptCode}">
                                        <path value="Observation.code.coding"/>
                                        <sliceName value="{$conceptCode}"/>
                                    </element>
                                    <element id="Observation.code.coding:{$conceptCode}.system">
                                        <path value="Observation.code.coding.system"/>
                                        <fixedUri value="{$conceptCodeSystem}"/>
                                    </element>
                                    <element id="Observation.code.coding:{$conceptCode}.code">
                                        <path value="Observation.code.coding.code"/>
                                        <fixedCode value="{$conceptCode}"/>
                                    </element>
                                    <element id="Observation.code.coding:{$conceptCode}.display">
                                        <path value="Observation.code.coding.display"/>
                                        <fixedString value="{$conceptDisplay}"/>
                                    </element>
                                </xsl:when>
                                <!-- tijdelijke workaround tot loinc code in ada is opgenomen -->
                                <xsl:when test="$conceptName='Datum einde zwangerschap'">
                                    <element id="Observation.code.coding">
                                        <path value="Observation.code.coding"/>
                                        <slicing>
                                            <discriminator>
                                                <type value="value"/>
                                                <path value="code"/>
                                            </discriminator>
                                            <rules value="open"/>
                                        </slicing>
                                    </element>
                                    <element id="Observation.code.coding:datumEindeZwangerschap">
                                        <path value="Observation.code.coding"/>
                                        <sliceName value="datumEindeZwangerschap"/>
                                    </element>
                                    <element id="Observation.code.coding:datumEindeZwangerschap.system">
                                        <path value="Observation.code.coding.system"/>
                                        <fixedUri value="http://loinc.org"/>
                                    </element>
                                    <element id="Observation.code.coding:datumEindeZwangerschap.code">
                                        <path value="Observation.code.coding.code"/>
                                        <fixedCode value="63963-3"/>
                                    </element>
                                    <element id="Observation.code.coding:datumEindeZwangerschap.display">
                                        <path value="Observation.code.coding.display"/>
                                        <fixedString value="Date of end of pregnancy"/>
                                    </element>                                   
                                </xsl:when>
                            </xsl:choose>
                            
                            <!-- subject is kind bij geboortegegevens, anders altijd de moeder -->
                            <xsl:choose>
                                <xsl:when test="$focus='Geboorte'">
                                    <element id="Observation.subject">
                                        <path value="Observation.subject"/>
                                        <type>
                                            <code value="Reference"/>
                                            <targetProfile value="http://nictiz.nl/fhir/StructureDefinition/StructureDefinition/bc-Child"/>
                                        </type>
                                    </element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <element id="Observation.subject">
                                        <path value="Observation.subject"/>
                                        <type>
                                            <code value="Reference"/>
                                            <targetProfile value="http://nictiz.nl/fhir/StructureDefinition/StructureDefinition/bc-Woman"/>
                                        </type>
                                    </element>                                    
                                </xsl:otherwise>
                            </xsl:choose>
                                  
                            <!-- constraints value[x] element obv datatype -->
                            <xsl:choose>
                                <xsl:when test="$dataType='Code'">                                 
                                    <element id="Observation.value[x]:valueCodeableConcept">
                                        <path value="Observation.valueCodeableConcept" />
                                        <sliceName value="valueCodeableConcept" />
                                        <type>
                                            <code value="CodeableConcept" />
                                        </type>
                                    </element>
                                    <element id="Observation.value[x]:valueCodeableConcept.coding">
                                        <path value="Observation.valueCodeableConcept.coding" />
                                        <slicing>
                                            <discriminator>
                                                <type value="value" />
                                                <path value="code" />
                                            </discriminator>
                                            <rules value="open" />
                                        </slicing>
                                    </element>
                                    <element id="Observation.value[x]:valueCodeableConcept.coding:{$conceptCode}">
                                        <path value="Observation.valueCodeableConcept.coding" />
                                        <sliceName value="{$conceptCode}" />
                                        <binding>
                                            <strength value="extensible" />
                                            <description value="{$valueSetName}" />
                                            <valueSetUri value="http://decor.nictiz.nl/fhir/ValueSet/{$valueSetID}--{$effective}" />
                                        </binding>
                                        <mapping>
                                            <identity value="gebz-peri-v2.3" />
                                            <map value="{$conceptIdDisplay}" />
                                            <comment value="{$conceptName}" />
                                        </mapping>
                                    </element>                                             
                                </xsl:when>
                                <xsl:when test="$dataType='Datum/tijd'">
                                    <element id="Observation.value[x]:valueDateTime">
                                        <path value="Observation.valueDateTime" />
                                        <sliceName value="valueDateTime" />
                                        <type>
                                            <code value="dateTime" />
                                        </type>
                                        <mapping>
                                            <identity value="gebz-peri-v2.3" />
                                            <map value="{$conceptIdDisplay}" />
                                            <comment value="{$conceptName}" />
                                        </mapping>
                                    </element>
                                </xsl:when>
                                <xsl:when test="$dataType='Boolean'">
                                    <element id="Observation.value[x]:valueBoolean">
                                        <path value="Observation.valueBoolean"/>
                                        <sliceName value="valueBoolean"/>
                                        <type>
                                            <code value="boolean"/>
                                        </type>
                                        <mapping>
                                            <identity value="gebz-peri-v2.3" />
                                            <map value="{$conceptIdDisplay}" />
                                            <comment value="{$conceptName}" />
                                        </mapping>
                                    </element>
                                </xsl:when>
                                <xsl:when test="$dataType='Hoeveelheid'">
                                    <element id="Observation.value[x]:valueQuantity">
                                        <path value="Observation.valueQuantity" />
                                        <sliceName value="valueQuantity" />
                                        <type>
                                            <code value="Quantity" />
                                        </type>
                                        <mapping>
                                            <identity value="gebz-peri-v2.3" />
                                            <map value="{$conceptIdDisplay}" />
                                            <comment value="{$conceptName}" />
                                        </mapping>
                                    </element>
                                    <element id="Observation.value[x]:valueQuantity.system">
                                        <path value="Observation.valueQuantity.system" />
                                        <fixedUri value="https://unitsofmeasure.org" />
                                    </element>
                                </xsl:when>
                            </xsl:choose>
                        </differential>
                    </StructureDefinition>
                    <!-- einde XML StructureDefinition -->
                    
                </xsl:result-document>                
            </xsl:for-each>  
            
        </xsl:for-each>
            
    </xsl:template>
</xsl:stylesheet>