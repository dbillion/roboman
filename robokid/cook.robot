*** Settings ***
Documentation     Template
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Desktop
Library    RPA.Excel.Files
Library           RPA.HTTP
Library           RPA.PDF

*** Tasks ***
Open the website
    Open website

Read companies from Excel and add to website
    Fill the form using the data from the Excel File    

*** Keywords ***
Open website
    Open Available Browser    https://www.rpa-unlimited.com/youtube/robocorp-tutorial/

fill and submit form for every company
    [Arguments]     ${company}
    Input Text    company-name    ${company}[Company Name]    
    Input Text    company-contact    ${company}[Contact Person]   

    Input Text    address    ${company}[Address]   

    Input Text    zipcode    ${company}[Zipcode]   

    Input Text    city    ${company}[City]   

    Input Text    country    ${company}[Country]    
    Input Text    telephone    ${company}[Telephone]   

    Input Text    email    ${company}[Email]   
    Submit Form

fill the form using the data from the excel file

    Open Workbook        Input.xlsx
    ${companies}=    Read Worksheet As Table    header=True
    Close Workbook    
    FOR    ${company}    IN    @{companies}
        fill and submit form for every company   ${company}
        
    END