*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.Desktop
Library           RPA.Tables
Library           RPA.HTTP
Library           RPA.PDF
Library           RPA.Robocorp.Vault
Library           RPA.Archive


# ...               Saves the order HTML receipt as a PDF file.
# ...               Saves the screenshot of the ordered robot.
# ...               Embeds the screenshot of the robot to the PDF receipt.
# ...               Creates ZIP archive of the receipts and the images.

*** Variables ***
${OUTPUT_DIR}    ./output
${i}              0

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the intranet website   
    Get orders
    Fill the form using the data from the Excel file

# Saves the order HTML receipt as a PDF file.




*** Keywords ***
Open the intranet website
    Open Available Browser   https://robotsparebinindustries.com/
Get orders
    Click Link    link:Order your robot!
    Click Button    css:Button.btn.btn-dark
    Sleep    5s
    # Click Button    css:.form-group>button.btn.btn-secondary

Fill and submit the form for one person
    [Arguments]    ${orders}
    Select From List By Index   head    ${orders}[Head]
    Select Radio Button  body    ${orders}[Body]
    Input Text    css:.form-control[placeholder="Enter the part number for the legs"]    ${orders}[Legs]
    Input Text    address    ${orders}[Address]
    
    # FOR    ${i}    IN RANGE    4    
    #     ${status}=  Run Keyword And Return Status   Click Button   preview
    #     Wait Until Keyword Succeeds    5s    1s    Click Button   preview
    #     Exit For Loop If   ${status}

    # END
    Wait Until Element Is Visible    preview
    Click Button    preview
    Wait Until Keyword Succeeds    5s    1s    Click Button   preview

    Wait Until Element Is Visible    css:div#robot-preview-image
    Screenshot    css:div#robot-preview-image    ${OUTPUT_DIR}${/}robot-preview-image.png
    ${robot-preview-image}=    Get Element Attribute    id:robot-preview-image   outerHTML

    # FOR    ${i}    IN RANGE    4    
    #     ${status}=  Run Keyword And Return Status   Click Button   order
    #     Wait Until Keyword Succeeds    5s    1s    Click Button   order
    #     Exit For Loop If   ${status}
    # END
    Wait Until Element Is Visible    order
    
    # Click Button    order
    Wait Until Keyword Succeeds    5s    1s    Click Button   order
    Sleep    2s
    Wait Until Element Is Visible    id:receipt
    ${receipt}=    Get Element Attribute    id:receipt  outerHTML
    Open PDF    ${OUTPUT_DIR}${/}receipt.pdf
    # Add Watermark Image To Pdf    /${robot-preview-image}.png    ${OUTPUT_DIR}${/}receipts/fullreceipt.pd
    # FOR    ${i}    IN RANGE    4    
    #     ${status}=  Run Keyword And Return Status   Click Button   order-another
    #     Wait Until Keyword Succeeds    5s    1s    Click Button   order-another
    #     Exit For Loop If   ${status}
    # END
    Wait Until Element Is Visible    order-another
    # Click Button    order-another
    Wait Until Keyword Succeeds    10s    1s    Click Button   order-another
    Wait Until Element Is Visible    css:Button.btn.btn-dark
    # Click Button    css:Button.btn.btn-dark
    Wait Until Keyword Succeeds    5s    1s    Click Button   css:Button.btn.btn-dark

    

Fill the form using the data from the Excel file
    
    ${orders}=   Read table from CSV    orders.csv
    ...    header=True
    
    FOR    ${row}    IN    @{orders}
   
        ${status}=  Run Keyword And Return Status  Fill and submit the form for one person  ${row}
        Run Keyword Unless  ${status}  Log to console  The order for row ${row} failed
     
    END

close the browser
    Close Browser