Import-Module PSSharedGoods -Force
Import-Module PSWinReportingV2 -Force

$Options = [ordered] @{
    JustTestPrerequisite = $false # runs testing without actually running script

    AsExcel              = @{
        Enabled     = $false # creates report in XLSX
        OpenAsFile  = $false
        Path        = 'C:\down\evo\ExportedEvents'
        FilePattern = 'Evotec-ADMonitoredEvents-<currentdate>.xlsx'
        DateFormat  = 'yyyy-MM-dd-HH_mm_ss'
    }
    AsCSV                = @{
        Enabled     = $false
        OpenAsFile  = $false
        Path        = 'C:\down\evo\ExportedEvents'
        FilePattern = 'Evotec-ADMonitoredEvents-<currentdate>-<reportname>.csv'
        DateFormat  = 'yyyy-MM-dd-HH_mm_ss'
        # Keep in mind <reportname> is critical here
        # if you don't use it next file will overwrite the old one
    }
    AsHTML               = @{
        Enabled     = $true # creates report in HTML
        OpenAsFile  = $true # requires AsHTML set to $true
        Path        = 'C:\down\evo\ExportedEvents'
        FilePattern = 'Evotec-ADMonitoredEvents-StaticHTML-<currentdate>.html'
        DateFormat  = 'yyyy-MM-dd-HH_mm_ss'
        Formatting  = @{
            CompanyBranding = @{
                Logo   = '' #can this be base64 encoded to embed?
                Width  = '0'
                Height = ''
                Link   = ''
                Inline = $false
            }
            FontFamily             = 'Calibri Light'
            FontSize               = '9pt'
            FontHeadingFamily      = 'Calibri Light'
            FontHeadingSize        = '12pt'
            FontTableHeadingFamily = 'Calibri Light'
            FontTableHeadingSize   = '9pt'
            FontTableDataFamily    = 'Calibri Light'
            FontTableDataSize      = '9pt'
            Colors                 = @{
                # case sensitive
                Red   = 'removed', 'deleted', 'locked out', 'lockouts', 'disabled', 'Domain Admins', 'was cleared'
                Blue  = 'changed', 'changes', 'change', 'reset'
                Green = 'added', 'enabled', 'unlocked', 'created'
            }
            Styles                 = @{
                # case sensitive
                B = 'status', 'Domain Admins', 'Enterprise Admins', 'Schema Admins', 'was cleared', 'lockouts' # BOLD
                I = '' # Italian
                U = 'status'# Underline
            }
            Links                  = @{

            }
        }
    }
    AsDynamicHTML        = @{
        Enabled     = $false # creates report in Dynamic HTML
        OpenAsFile  = $true
        Title       = 'Windows Events'
        Path        = 'C:\down\evo\ExportedEvents'
        FilePattern = 'Evotec-ADMonitoredEvents-DynamicHTML-<currentdate>.html'
        DateFormat  = 'yyyy-MM-dd-HH_mm_ss'
        Branding    = @{
            Logo = @{
                Show      = $true
                RightLogo = @{
                    ImageLink = '\\crrc-it\it\Storage\Pics'
                    Width     = '200'
                    Height    = ''
                    Link      = ''
                }
            }
        }
        EmbedCSS    = $false
        EmbedJS     = $false
    }
    AsSql                = @{
        Enabled               = $false
        SqlServer             = 'EVO1'
        SqlDatabase           = 'SSAE18'
        SqlTable              = 'dbo.[Events]'
        # Left side is data in PSWinReporting. Right Side is ColumnName in SQL
        # Changing makes sense only for right side...
        SqlTableCreate        = $true
        SqlTableAlterIfNeeded = $false # if table mapping is defined doesn't do anything
        SqlCheckBeforeInsert  = 'EventRecordID', 'DomainController' # Based on column name


        SqlTableMapping       = [ordered] @{
            'Event ID'               = 'EventID,[int]'
            'Who'                    = 'EventWho'
            'When'                   = 'EventWhen,[datetime]'
            'Record ID'              = 'EventRecordID,[bigint]'
            'Domain Controller'      = 'DomainController'
            'Action'                 = 'Action'
            'Group Name'             = 'GroupName'
            'User Affected'          = 'UserAffected'
            'Member Name'            = 'MemberName'
            'Computer Lockout On'    = 'ComputerLockoutOn'
            'Reported By'            = 'ReportedBy'
            'SamAccountName'         = 'SamAccountName'
            'Display Name'           = 'DisplayName'
            'UserPrincipalName'      = 'UserPrincipalName'
            'Home Directory'         = 'HomeDirectory'
            'Home Path'              = 'HomePath'
            'Script Path'            = 'ScriptPath'
            'Profile Path'           = 'ProfilePath'
            'User Workstation'       = 'UserWorkstation'
            'Password Last Set'      = 'PasswordLastSet'
            'Account Expires'        = 'AccountExpires'
            'Primary Group Id'       = 'PrimaryGroupId'
            'Allowed To Delegate To' = 'AllowedToDelegateTo'
            'Old Uac Value'          = 'OldUacValue'
            'New Uac Value'          = 'NewUacValue'
            'User Account Control'   = 'UserAccountControl'
            'User Parameters'        = 'UserParameters'
            'Sid History'            = 'SidHistory'
            'Logon Hours'            = 'LogonHours'
            'OperationType'          = 'OperationType'
            'Message'                = 'Message'
            'Backup Path'            = 'BackupPath'
            'Log Type'               = 'LogType'
            'AddedWhen'              = 'EventAdded,[datetime],null' # ColumnsToTrack when it was added to database and by who / not part of event
            'AddedWho'               = 'EventAddedWho'  # ColumnsToTrack when it was added to database and by who / not part of event
            'Gathered From'          = 'GatheredFrom'
            'Gathered LogName'       = 'GatheredLogName'
        }
    }
    SendMail             = @{
        Enabled     = $true

        InlineHTML  = $true # this goes inline - if empty email will have no content

        Attach      = @{
            XLSX        = $false # this goes as attachment
            CSV         = $false # this goes as attachment
            DynamicHTML = $false # this goes as attachment
            HTML        = $false # this goes as attachment
            # if all 4 above are false email will have no attachment
            # remember that for this to work each part has to be enabled
            # using attach XLSX without generating XLSX won't magically let it attach
        }
        KeepReports = @{
            XLSX        = $true # keeps files after reports are sent
            CSV         = $true # keeps files after reports are sent
            HTML        = $true # keeps files after reports are sent
            DynamicHTML = $true # keeps files after reports are sent
        }
        Parameters  = @{
            From             = 'ADEventReport@mydomain.com'
            To               = 'mymail@mydomain.com' #Arriva-se@support.euvic.pl
            CC               = ''
            BCC              = ''
            ReplyTo          = ''
            Server           = 'mail01.mydomain.local'
            Password         = 'PASSWORD'
            PasswordAsSecure = $false
            PasswordFromFile = $false
            Port             = '587'
            Login            = 'USERNAME'
            EnableSSL        = 1
            Encoding         = 'Unicode'
            Subject          = '[AD Reporting] Event Changes for period <<DateFrom>> to <<DateTo>>'
            Priority         = 'Low'
        }
    }
    RemoveDuplicates     = @{
        Enabled    = $true # when multiple sources are used it's normal for duplicates to occur. This cleans it up.
        Properties = 'RecordID', 'Computer'
    }
    Logging              = @{
        ShowTime   = $true
        LogsDir    = 'C:\down\evo\logs'
        TimeFormat = 'yyyy-MM-dd HH:mm:ss'
    }
    Debug                = @{
        DisplayTemplateHTML = $false
        Verbose             = $false
    }
} #asHTML & SendMail
$Target = [ordered]@{
    Servers           = [ordered] @{
        Enabled = $false
        # Server1 = @{ ComputerName = 'EVO1'; LogName = 'ForwardedEvents' }
        # Server3 = 'AD1.ad.evotec.xyz'
    }
    DomainControllers = [ordered] @{
        Enabled = $true
    }
    LocalFiles        = [ordered] @{
        Enabled     = $false
        Directories = [ordered] @{
            #MyEvents = 'C:\MyEvents' #
            #MyOtherEvent = 'C:\MyEvent1'
        }
        Files       = [ordered] @{
            File1 = 'C:\down\evo\Archive-Security-2018-09-14-22-13-07-710.evtx'
        }
    }
} # DomainControllers
$Times = @{
    PastHour             = @{
        Enabled = $false # if it's 23:22 it will report 22:00 till 23:00
    } # Report Per Hour
    CurrentHour          = @{
        Enabled = $false # if it's 23:22 it will report 23:00 till 00:00
    }
    PastDay              = @{
        Enabled = $true # if it's 1.04.2018 it will report 31.03.2018 00:00:00 till 01.04.2018 00:00:00
    } # Report Per Day
    CurrentDay           = @{
        Enabled = $false # if it's 1.04.2018 05:22 it will report 1.04.2018 00:00:00 till 01.04.2018 00:00:00
    }
    OnDay                = @{
        Enabled = $false
        Days    = 'Monday'#, 'Tuesday'
    } # Report Per Week
    PastMonth            = @{
        Enabled = $false # checks for 1st day of the month - won't run on any other day unless used force
        Force   = $false  # if true - runs always ...
    } # Report Per Month
    CurrentMonth         = @{
        Enabled = $false
    }
    PastQuarter          = @{
        Enabled = $false # checks for 1st day fo the quarter - won't run on any other day
        Force   = $false # if true - runs always ...
    } # Report Per Quarter
    CurrentQuarter       = @{
        Enabled = $false
    }
    CurrentDayMinusDayX  = @{
        Enabled = $false
        Days    = 7    # goes back X days and shows just 1 day
    } # Report Custom
    CurrentDayMinuxDaysX = @{
        Enabled = $false
        Days    = 5 # goes back X days and shows X number of days till Today
    }
    CustomDate           = @{
        Enabled  = $false
        #DateFrom = get-date -Year 2019 -Month 06 -Day 10
        #DateTo   = get-date -Year 2019 -Month 06 -Day 11
        DateFrom = [DateTime]::Today.AddDays(-1).AddHours(7)
        DateTo   = [DateTime]::Today.AddHours(7)
    }
    Last3days            = @{
        Enabled = $false
    }
    Last7days            = @{
        Enabled = $false
    }
    Last14days           = @{
        Enabled = $false
    }
    Everything           = @{
        Enabled = $false
    }
} # Current Day
## Define reports
$DefinitionsAD = [ordered] @{
    ADUserChanges                       = @{
        Enabled   = $true
        SqlExport = @{
            EnabledGlobal         = $false
            Enabled               = $false
            SqlServer             = 'EVO1'
            SqlDatabase           = 'SSAE18'
            SqlTable              = 'dbo.[EventsNewSpecial]'
            # Left side is data in PSWinReporting. Right Side is ColumnName in SQL
            # Changing makes sense only for right side...
            SqlTableCreate        = $true
            SqlTableAlterIfNeeded = $false # if table mapping is defined doesn't do anything
            SqlCheckBeforeInsert  = 'EventRecordID', 'DomainController' # Based on column name

            SqlTableMapping       = [ordered] @{
                'Event ID'               = 'EventID,[int]'
                'Who'                    = 'EventWho'
                'When'                   = 'EventWhen,[datetime]'
                'Record ID'              = 'EventRecordID,[bigint]'
                'Domain Controller'      = 'DomainController'
                'Action'                 = 'Action'
                'Group Name'             = 'GroupName'
                'User Affected'          = 'UserAffected'
                'Member Name'            = 'MemberName'
                'Computer Lockout On'    = 'ComputerLockoutOn'
                'Reported By'            = 'ReportedBy'
                'SamAccountName'         = 'SamAccountName'
                'Display Name'           = 'DisplayName'
                'UserPrincipalName'      = 'UserPrincipalName'
                'Home Directory'         = 'HomeDirectory'
                'Home Path'              = 'HomePath'
                'Script Path'            = 'ScriptPath'
                'Profile Path'           = 'ProfilePath'
                'User Workstation'       = 'UserWorkstation'
                'Password Last Set'      = 'PasswordLastSet'
                'Account Expires'        = 'AccountExpires'
                'Primary Group Id'       = 'PrimaryGroupId'
                'Allowed To Delegate To' = 'AllowedToDelegateTo'
                'Old Uac Value'          = 'OldUacValue'
                'New Uac Value'          = 'NewUacValue'
                'User Account Control'   = 'UserAccountControl'
                'User Parameters'        = 'UserParameters'
                'Sid History'            = 'SidHistory'
                'Logon Hours'            = 'LogonHours'
                'OperationType'          = 'OperationType'
                'Message'                = 'Message'
                'Backup Path'            = 'BackupPath'
                'Log Type'               = 'LogType'
                'AddedWhen'              = 'EventAdded,[datetime],null' # ColumnsToTrack when it was added to database and by who / not part of event
                'AddedWho'               = 'EventAddedWho'  # ColumnsToTrack when it was added to database and by who / not part of event
                'Gathered From'          = 'GatheredFrom'
                'Gathered LogName'       = 'GatheredLogName'
            }
        }
        Events    = @{
            Enabled     = $true
            Events      = 4720, 4738
            # 4720: Account Management - User Account Management - A user account was created.
            # 4738: Account Management - User Account Management - A user account was changed.
            LogName     = 'Security'
            Fields      = [ordered] @{
                #'Computer'            = 'Domain Controller'
                'Action'              = 'Action'
                'ObjectAffected'      = 'User Affected'
                'SamAccountName'      = 'SamAccountName'
                'DisplayName'         = 'DisplayName'
                'UserPrincipalName'   = 'UserPrincipalName'
                #'HomeDirectory'       = 'Home Directory'
                #'HomePath'            = 'Home Path'
                #'ScriptPath'          = 'Script Path'
                #'ProfilePath'         = 'Profile Path'
                #'UserWorkstations'    = 'User Workstations'
                'PasswordLastSet'     = 'Password Last Set'
                #'AccountExpires'      = 'Account Expires'
                #'PrimaryGroupId'      = 'Primary Group Id'
                #'AllowedToDelegateTo' = 'Allowed To Delegate To'
                #'OldUacValue'         = 'Old Uac Value'
                #'NewUacValue'         = 'New Uac Value'
                #'UserAccountControl'  = 'User Account Control'
                #'UserParameters'      = 'User Parameters'
                #'SidHistory'          = 'Sid History'
                'Who'                 = 'Who'
                'Date'                = 'When'
                # Common Fields
                'ID'                  = 'Event ID'
                'RecordID'            = 'Record ID'
                'GatheredFrom'        = 'Gathered From'
                'GatheredLogName'     = 'Gathered LogName'
            }
            Ignore      = @{
                # Cleanup Anonymous LOGON (usually related to password events) # https://social.technet.microsoft.com/Forums/en-US/5b2a93f7-7101-43c1-ab53-3a51b2e05693/eventid-4738-user-account-was-changed-by-anonymous?forum=winserverDS
                SubjectUserName = "ANONYMOUS LOGON"
                Who             = "NT AUTHORITY\ANONYMOUS LOGON"
                # Test value
                #ProfilePath     = 'C*'
            }
            Functions   = @{
                'ProfilePath'        = 'Convert-UAC'
                'OldUacValue'        = 'Remove-WhiteSpace', 'Convert-UAC'
                'NewUacValue'        = 'Remove-WhiteSpace', 'Convert-UAC'
                'UserAccountControl' = 'Remove-WhiteSpace', 'Split-OnSpace', 'Convert-UAC'
            }
            IgnoreWords = @{
                #'Profile Path' = 'TEMP*'
            }
            SortBy      = 'When'
        }
    }           # 4720,4738
    ADUserChangesDetailed               = [ordered] @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 5136, 5137, 5141
            #5136: DS Access - Directory Service Changes - A directory service object was modified.
            #5137: DS Access - Directory Service Changes - A directory service object was created.
            #5141: DS Access - Directory Service Changes - A directory service object was deleted.
            LogName     = 'Security'
            Filter      = @{
                'ObjectClass' = 'user'
            }
            Functions   = @{
                'OperationType' = 'ConvertFrom-OperationType'
            }
            Fields      = [ordered] @{
                #'Computer'                 = 'Domain Controller'
                'Action'                   = 'Action'
                'OperationType'            = 'Action Detail'
                'Who'                      = 'Who'
                'Date'                     = 'When'
                'ObjectDN'                 = 'User Object'
                'AttributeLDAPDisplayName' = 'Field Changed'
                'AttributeValue'           = 'Field Value'
                # Common Fields
                'RecordID'                 = 'Record ID'
                'ID'                       = 'Event ID'
                'GatheredFrom'             = 'Gathered From'
                #'GatheredLogName'          = 'Gathered LogName'
            }
            SortBy      = 'Record ID'
            Descending  = $false
            IgnoreWords = @{

            }
        }
    } # 5136,5137,5141
    ADComputerChangesDetailed           = [ordered] @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 5136, 5137, 5141
            #5136: DS Access - Directory Service Changes - A directory service object was modified.
            #5137: DS Access - Directory Service Changes - A directory service object was created.
            #5141: DS Access - Directory Service Changes - A directory service object was deleted.
            LogName     = 'Security'
            Filter      = @{
                'ObjectClass' = 'computer'
            }
            Functions   = @{
                'OperationType' = 'ConvertFrom-OperationType'
            }
            Fields      = [ordered] @{
                #'Computer'                 = 'Domain Controller'
                'Action'                   = 'Action'
                'OperationType'            = 'Action Detail'
                'Who'                      = 'Who'
                'Date'                     = 'When'
                'ObjectDN'                 = 'Computer Object'
                'AttributeLDAPDisplayName' = 'Field Changed'
                'AttributeValue'           = 'Field Value'
                # Common Fields
                'RecordID'                 = 'Record ID'
                'ID'                       = 'Event ID'
                'GatheredFrom'             = 'Gathered From'
                #'GatheredLogName'          = 'Gathered LogName'
            }
            Ignore      = @{
                # Cleanup Anonymous LOGON (usually related to password events) # https://social.technet.microsoft.com/Forums/en-US/5b2a93f7-7101-43c1-ab53-3a51b2e05693/eventid-4738-user-account-was-changed-by-anonymous?forum=winserverDS
                'Field Value' = "WSMAN*","CmRcService*","TERMSRV*"
                # Test value
                #ProfilePath     = 'C*'
            }
            SortBy      = 'Record ID'
            Descending  = $false
            IgnoreWords = @{
                #'Field Value' = '*WSMAN*'
            }
        }
    } # 5136,5137,5141
    ADOrganizationalUnitChangesDetailed = [ordered] @{
        Enabled        = $true
        OUEventsModify = @{
            Enabled          = $true
            Events           = 5136, 5137, 5139, 5141
            #5136: DS Access - Directory Service Changes - A directory service object was modified.
            #5137: DS Access - Directory Service Changes - A directory service object was created.
            #5139: DS Access - Directory Service Changes - A directory service object was moved.
            #5141: DS Access - Directory Service Changes - A directory service object was deleted.
            LogName          = 'Security'
            Filter           = @{
                'ObjectClass' = 'organizationalUnit'
            }
            Functions        = @{
                'OperationType' = 'ConvertFrom-OperationType'
            }
            Fields           = [ordered] @{
                'Computer'                 = 'Domain Controller'
                'Action'                   = 'Action'
                'OperationType'            = 'Action Detail'
                'Who'                      = 'Who'
                'Date'                     = 'When'
                'ObjectDN'                 = 'Organizational Unit'
                'AttributeLDAPDisplayName' = 'Field Changed'
                'AttributeValue'           = 'Field Value'
                #'OldObjectDN'              = 'OldObjectDN'
                #'NewObjectDN'              = 'NewObjectDN'
                # Common Fields
                'RecordID'                 = 'Record ID'
                'ID'                       = 'Event ID'
                'GatheredFrom'             = 'Gathered From'
                'GatheredLogName'          = 'Gathered LogName'
            }
            Overwrite        = @{
                'Action Detail#1' = 'Action', 'A directory service object was created.', 'Organizational Unit Created'
                'Action Detail#2' = 'Action', 'A directory service object was deleted.', 'Organizational Unit Deleted'
                'Action Detail#3' = 'Action', 'A directory service object was moved.', 'Organizational Unit Moved'
                #'Organizational Unit' = 'Action', 'A directory service object was moved.', 'OldObjectDN'
                #'Field Changed'       = 'Action', 'A directory service object was moved.', ''
                #'Field Value'         = 'Action', 'A directory service object was moved.', 'NewObjectDN'
            }
            # This Overwrite works in a way where you can swap one value with another value from another field within same Event
            # It's useful if you have an event that already has some fields used but empty and you wnat to utilize them
            # for some content
            OverwriteByField = @{
                'Organizational Unit' = 'Action', 'A directory service object was moved.', 'OldObjectDN'
                #'Field Changed'       = 'Action', 'A directory service object was moved.', ''
                'Field Value'         = 'Action', 'A directory service object was moved.', 'NewObjectDN'
            }
            SortBy           = 'Record ID'
            Descending       = $false
            IgnoreWords      = @{}
        }
    } # 5136,5137,5139,5141
    ADUserStatus                        = @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4722, 4725, 4767, 4723, 4724, 4726
            #4722: Account Management - User Account Management - A user account was enabled.
            #4723: Account Management - User Account Management - An attempt was made to change an account's password.
            #4724: Account Management - User Account Management - An attempt was made to reset an account's password.
            #4725: Account Management - User Account Management - A user account was disabled.
            #4726: Account Management - User Account Management - A user account was deleted.
            #4767: Account Management - User Account Management - A user account was unlocked.
            LogName     = 'Security'
            IgnoreWords = @{}
            Fields      = [ordered] @{
                #'Computer'        = 'Domain Controller'
                'Action'          = 'Action'
                'Who'             = 'Who'
                'Date'            = 'When'
                'ObjectAffected'  = 'User Affected'
                # Common Fields
                'ID'              = 'Event ID'
                'RecordID'        = 'Record ID'
                'GatheredFrom'    = 'Gathered From'
                #'GatheredLogName' = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4722,4723,4724,4725,4726,4767
    ADUserLockouts                      = @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4740
            #4740: Account Management - User Account Management - A user account was locked out.
            LogName     = 'Security'
            IgnoreWords = @{}
            Fields      = [ordered] @{
                #'Computer'         = 'Domain Controller'
                'Action'           = 'Action'
                'TargetDomainName' = 'Computer Lockout On'
                'ObjectAffected'   = 'User Affected'
                #'Who'              = 'Reported By'
                'Date'             = 'When'
                # Common Fields
                'ID'               = 'Event ID'
                #'RecordID'         = 'Record ID'
                'GatheredFrom'     = 'Gathered From'
                'GatheredLogName'  = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4740
    ADUserLogon                         = @{
        Enabled = $false
        Events  = @{
            Enabled     = $false
            Events      = 4624
            #4624: Logon/Logoff - Logon - An account was successfully logged on.
            LogName     = 'Security'
            Fields      = [ordered] @{
                'Computer'           = 'Computer'
                'Action'             = 'Action'
                'IpAddress'          = 'IpAddress'
                'IpPort'             = 'IpPort'
                'ObjectAffected'     = 'User / Computer Affected'
                'Who'                = 'Who'
                'Date'               = 'When'
                'LogonProcessName'   = 'LogonProcessName'
                'ImpersonationLevel' = 'ImpersonationLevel' # %%1833 = Impersonation
                'VirtualAccount'     = 'VirtualAccount'  #  %%1843 = No
                'ElevatedToken'      = 'ElevatedToken' # %%1842 = Yes
                'LogonType'          = 'LogonType'
                # Common Fields
                'ID'                 = 'Event ID'
                'RecordID'           = 'Record ID'
                'GatheredFrom'       = 'Gathered From'
                'GatheredLogName'    = 'Gathered LogName'
            }
            IgnoreWords = @{}
        }
    }           # 4624 (Disabled)
    ADUserUnlocked                      = @{
        # 4767	A user account was unlocked
        # https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=4767
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4767
            #4767: Account Management - User Account Management - A user account was unlocked.
            LogName     = 'Security'
            IgnoreWords = @{}
            Functions   = @{}
            Fields      = [ordered] @{
                #'Computer'         = 'Domain Controller'
                'Action'           = 'Action'
                'TargetDomainName' = 'Computer Lockout On'
                'ObjectAffected'   = 'User Affected'
                'Who'              = 'Who'
                'Date'             = 'When'
                # Common Fields
                'ID'               = 'Event ID'
                #'RecordID'         = 'Record ID'
                'GatheredFrom'     = 'Gathered From'
                'GatheredLogName'  = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4767
    ADComputerCreatedChanged            = @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4741, 4742 # created, changed
            #4741: Account Logon - Kerberos Authentication Service - Kerberos pre-authentication failed.
            #4742: Account Logon - Kerberos Authentication Service - A Kerberos authentication ticket request failed.
            LogName     = 'Security'
            Ignore      = @{
                # Cleanup Anonymous LOGON (usually related to password events)
                # https://social.technet.microsoft.com/Forums/en-US/5b2a93f7-7101-43c1-ab53-3a51b2e05693/eventid-4738-user-account-was-changed-by-anonymous?forum=winserverDS
                SubjectUserName = "ANONYMOUS LOGON"
            }
            Fields      = [ordered] @{
                #'Computer'            = 'Domain Controller'
                'Action'              = 'Action'
                'ObjectAffected'      = 'Computer Affected'
                #'SamAccountName'      = 'SamAccountName'
                #'DisplayName'         = 'DisplayName'
                #'UserPrincipalName'   = 'UserPrincipalName'
                #'HomeDirectory'       = 'Home Directory'
                #'HomePath'            = 'Home Path'
                #'ScriptPath'          = 'Script Path'
                #'ProfilePath'         = 'Profile Path'
                #'UserWorkstations'    = 'User Workstations'
                'PasswordLastSet'     = 'Password Last Set'
                #'AccountExpires'      = 'Account Expires'
                #'PrimaryGroupId'      = 'Primary Group Id'
                #'AllowedToDelegateTo' = 'Allowed To Delegate To'
                #'OldUacValue'         = 'Old Uac Value'
                #'NewUacValue'         = 'New Uac Value'
                #'UserAccountControl'  = 'User Account Control'
                #'UserParameters'      = 'User Parameters'
                #'SidHistory'          = 'Sid History'
                'Who'                 = 'Who'
                'Date'                = 'When'
                # Common Fields
                'ID'                  = 'Event ID'
                #'RecordID'            = 'Record ID'
                'GatheredFrom'        = 'Gathered From'
                'GatheredLogName'     = 'Gathered LogName'
            }
            IgnoreWords = @{
                'Who' = 'NY AUTHORITY\ANONYMOUS LOGON'
            }
        }
    }           # 4741,4742
    ADComputerDeleted                   = @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4743 # deleted
            #4743: Account Logon - Kerberos Authentication Service - A Kerberos service ticket request failed.
            LogName     = 'Security'
            IgnoreWords = @{}
            Fields      = [ordered] @{
                #'Computer'        = 'Domain Controller'
                'Action'          = 'Action'
                'ObjectAffected'  = 'Computer Affected'
                'Who'             = 'Who'
                'Date'            = 'When'
                # Common Fields
                'ID'              = 'Event ID'
                #'RecordID'        = 'Record ID'
                'GatheredFrom'    = 'Gathered From'
                #'GatheredLogName' = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4743
    ADUserLogonKerberos                 = @{
        Enabled = $false
        Events  = @{
            Enabled     = $false
            Events      = 4768
            #4768: Account Logon - Kerberos Authentication Service - A Kerberos authentication ticket (TGT) was requested.
            LogName     = 'Security'
            IgnoreWords = @{}
            Functions   = @{
                'IpAddress' = 'Clean-IpAddress'
            }
            Fields      = [ordered] @{
                'Computer'             = 'Domain Controller'
                'Action'               = 'Action'
                'ObjectAffected'       = 'Computer/User Affected'
                'IpAddress'            = 'IpAddress'
                'IpPort'               = 'Port'
                'TicketOptions'        = 'TicketOptions'
                'Status'               = 'Status'
                'TicketEncryptionType' = 'TicketEncryptionType'
                'PreAuthType'          = 'PreAuthType'
                'Date'                 = 'When'

                # Common Fields
                'ID'                   = 'Event ID'
                'RecordID'             = 'Record ID'
                'GatheredFrom'         = 'Gathered From'
                'GatheredLogName'      = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4768 (Disabled)
    ADGroupMembershipChanges            = @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4728, 4729, 4732, 4733, 4746, 4747, 4751, 4752, 4756, 4757, 4761, 4762, 4785, 4786, 4787, 4788
            #4728: Account Management - Security Group Management - A member was added to a security-enabled global group.
            #4729: Account Management - Security Group Management - A member was removed from a security-enabled global group.
            #4732: Account Management - Security Group Management - A member was added to a security-enabled local group.
            #4733: Account Management - Security Group Management - A member was removed from a security-enabled local group.
            #4746: Account Management - Distribution Group Management - A member was added to a security-disabled local group.
            #4747: Account Management - Distribution Group Management - A member was removed from a security-disabled local group.
            #4751: Account Management - Distribution Group Management - A member was added to a security-disabled global group.
            #4752: Account Management - Distribution Group Management - A member was removed from a security-disabled global group.
            #4756: Account Management - Security Group Management - A member was added to a security-enabled universal group.
            #4757: Account Management - Security Group Management - A member was removed from a security-enabled universal group.
            #4761: Account Management - Distribution Group Management - A member was added to a security-disabled universal group.
            #4762: Account Management - Distribution Group Management - A member was removed from a security-disabled universal group.
            #4785: Account Management - Application Group Management - A member was added to a basic application group.
            #4786: Account Management - Application Group Management - A member was removed from a basic application group.
            #4787: Account Management - Application Group Management - A non-member was added to a basic application group.
            #4788: Account Management - Application Group Management - A non-member was removed from a basic application group.
            LogName     = 'Security'
            IgnoreWords = @{
                'Who' = '*ANONYMOUS*'
            }
            Fields      = [ordered] @{
                #'Computer'            = 'Domain Controller'
                'Action'              = 'Action'
                'TargetUserName'      = 'Group Name'
                'MemberNameWithoutCN' = 'Member Name'
                'Who'                 = 'Who'
                'Date'                = 'When'
                # Common Fields
                'ID'                  = 'Event ID'
                'RecordID'            = 'Record ID'
                'GatheredFrom'        = 'Gathered From'
                #'GatheredLogName'     = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4728,4729,4732,4733,4746,4747,4751,4752,4756,4757,4761,4762,4785,4786,4787,4788
    ADGroupEnumeration                  = @{
        Enabled = $false
        Events  = @{
            Enabled     = $true
            Events      = 4798, 4799
            #4798: Account Management - User Account Management - A user's local group membership was enumerated. 
            #4799: Account Management - Security Group Management - A security-enabled local group membership was enumerated.
            LogName     = 'Security'
            IgnoreWords = @{
                #'Who' = '*ANONYMOUS*'
            }
            Fields      = [ordered] @{
                'Computer'        = 'Domain Controller'
                'Action'          = 'Action'
                'TargetUserName'  = 'Group Name'
                'Who'             = 'Who'
                'Date'            = 'When'
                # Common Fields
                'ID'              = 'Event ID'
                'RecordID'        = 'Record ID'
                'GatheredFrom'    = 'Gathered From'
                'GatheredLogName' = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4798,4799
    ADGroupChanges                      = @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4735, 4737, 4745, 4750, 4760, 4764, 4784, 4791
            #4735: Account Management - Security Group Management - A security-enabled local group was changed.
            #4737: Account Management - Security Group Management - A security-enabled global group was changed.
            #4745: Account Management - Distribution Group Management - A security-disabled local group was changed.
            #4750: Account Management - Distribution Group Management - A security-disabled global group was changed.
            #4760: Account Management - Distribution Group Management - A security-disabled universal group was changed.
            #4764: Account Management - Security Group Management - A group’s type was changed.
            #4784: Account Management - Application Group Management - A basic application group was changed.
            #4791: Account Management - Application Group Management - A basic application group was changed.
            LogName     = 'Security'
            IgnoreWords = @{
                'Who' = '*ANONYMOUS*'
            }
            Fields      = [ordered] @{
                #'Computer'        = 'Domain Controller'
                'Action'          = 'Action'
                'TargetUserName'  = 'Group Name'
                'Who'             = 'Who'
                'Date'            = 'When'
                'GroupTypeChange' = 'Changed Group Type'
                'SamAccountName'  = 'Changed SamAccountName'
                'SidHistory'      = 'Changed SidHistory'
                # Common Fields
                'ID'              = 'Event ID'
                'RecordID'        = 'Record ID'
                'GatheredFrom'    = 'Gathered From'
                #'GatheredLogName' = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4735,4737,4745,4750,4760,4764,4784,4791
    ADGroupCreateDelete                 = @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 4727, 4730, 4731, 4734, 4744, 4748, 4749, 4753, 4754, 4758, 4759, 4763
            #4727: Account Management - Security Group Management - A security-enabled global group was created.
            #4730: Account Management - Security Group Management - A security-enabled global group was deleted.
            #4731: Account Management - Security Group Management - A security-enabled local group was created.
            #4734: Account Management - Security Group Management - A security-enabled local group was deleted.
            #4744: Account Management - Distribution Group Management - A security-disabled local group was created.
            #4748: Account Management - Distribution Group Management - A security-disabled local group was deleted.
            #4749: Account Management - Distribution Group Management - A security-disabled global group was created.
            #4753: Account Management - Distribution Group Management - A security-disabled global group was deleted.
            #4754: Account Management - Security Group Management - A security-enabled universal group was created.
            #4758: Account Management - Security Group Management - A security-enabled universal group was deleted.
            #4759: Account Management - Distribution Group Management - A security-disabled universal group was created.
            #4763: 
            LogName     = 'Security'
            IgnoreWords = @{
                # 'Who' = '*ANONYMOUS*'
            }
            Fields      = [ordered] @{
                #'Computer'        = 'Domain Controller'
                'Action'          = 'Action'
                'TargetUserName'  = 'Group Name'
                'Who'             = 'Who'
                'Date'            = 'When'
                # Common Fields
                'ID'              = 'Event ID'
                'RecordID'        = 'Record ID'
                'GatheredFrom'    = 'Gathered From'
                #'GatheredLogName' = 'Gathered LogName'
            }
            SortBy      = 'When'
        }
    }           # 4727,4730,4731,4734,4744,4748,4749,4753,4754,4758,4759,4763
    ADGroupChangesDetailed              = [ordered] @{
        Enabled = $true
        Events  = @{
            Enabled     = $true
            Events      = 5136, 5137, 5141
            #5136: DS Access - Directory Service Changes - A directory service object was modified.
            #5137: DS Access - Directory Service Changes - A directory service object was created.
            #5141: DS Access - Directory Service Changes - A directory service object was deleted.
            LogName     = 'Security'
            Filter      = @{
                # Filter is special
                # if there is just one object on the right side it will filter on that field
                # if there are more objects filter will pick all values on the right side and display them (using AND)
                'ObjectClass' = 'group'
            }
            Functions   = @{
                'OperationType' = 'ConvertFrom-OperationType'
            }
            Fields      = [ordered] @{
                #'Computer'                 = 'Domain Controller'
                'Action'                   = 'Action'
                'OperationType'            = 'Action Detail'
                'Who'                      = 'Who'
                'Date'                     = 'When'
                'ObjectDN'                 = 'Computer Object'
                'ObjectClass'              = 'ObjectClass'
                'AttributeLDAPDisplayName' = 'Field Changed'
                'AttributeValue'           = 'Field Value'
                # Common Fields
                'RecordID'                 = 'Record ID'
                'ID'                       = 'Event ID'
                'GatheredFrom'             = 'Gathered From'
                #'GatheredLogName'          = 'Gathered LogName'
            }
            SortBy      = 'Record ID'
            Descending  = $false
            IgnoreWords = @{

            }
        }
    } # 5136,5137,5141
    ADGroupPolicyChanges                = [ordered] @{
        Enabled                     = $true
        'Group Policy Name Changes' = @{
            Enabled     = $true
            Events      = 5136, 5137, 5141
            #5136: DS Access - Directory Service Changes - A directory service object was modified.
            #5137: DS Access - Directory Service Changes - A directory service object was created.
            #5141: DS Access - Directory Service Changes - A directory service object was deleted.
            LogName     = 'Security'
            Filter      = @{
                # Filter is special, if there is just one object on the right side
                # If there are more objects filter will pick all values on the right side and display them as required
                'ObjectClass'              = 'groupPolicyContainer'
                #'OperationType'            = 'Value Added'
                'AttributeLDAPDisplayName' = $null, 'displayName' #, 'versionNumber'
            }
            Functions   = @{
                'OperationType' = 'ConvertFrom-OperationType'
            }
            Fields      = [ordered] @{
                'RecordID'                 = 'Record ID'
                #'Computer'                 = 'Domain Controller'
                'Action'                   = 'Action'
                'Who'                      = 'Who'
                'Date'                     = 'When'
                'ObjectDN'                 = 'ObjectDN'
                'ObjectGUID'               = 'ObjectGUID'
                'ObjectClass'              = 'ObjectClass'
                'AttributeLDAPDisplayName' = 'AttributeLDAPDisplayName'
                #'AttributeSyntaxOID'       = 'AttributeSyntaxOID'
                'AttributeValue'           = 'AttributeValue'
                'OperationType'            = 'OperationType'
                'OpCorrelationID'          = 'OperationCorelationID'
                'AppCorrelationID'         = 'OperationApplicationCorrelationID'
                'DSName'                   = 'DSName'
                'DSType'                   = 'DSType'
                'Task'                     = 'Task'
                'Version'                  = 'Version'
                # Common Fields
                'ID'                       = 'Event ID'
                'GatheredFrom'             = 'Gathered From'
                #'GatheredLogName'          = 'Gathered LogName'
            }

            SortBy      = 'Record ID'
            Descending  = $false
            IgnoreWords = @{

            }
        }  # 5136, 5137, 5141
        'Group Policy Edits'        = @{
            Enabled     = $true
            Events      = 5136, 5137, 5141
            #5136: DS Access - Directory Service Changes - A directory service object was modified.
            #5137: DS Access - Directory Service Changes - A directory service object was created.
            #5141: DS Access - Directory Service Changes - A directory service object was deleted.
            LogName     = 'Security'
            Filter      = @{
                # Filter is special, if there is just one object on the right side
                # If there are more objects filter will pick all values on the right side and display them as required
                'ObjectClass'              = 'groupPolicyContainer'
                #'OperationType'            = 'Value Added'
                'AttributeLDAPDisplayName' = 'versionNumber'
            }
            Functions   = @{
                'OperationType' = 'ConvertFrom-OperationType'
            }
            Fields      = [ordered] @{
                'RecordID'                 = 'Record ID'
                #'Computer'                 = 'Domain Controller'
                'Action'                   = 'Action'
                'Who'                      = 'Who'
                'Date'                     = 'When'
                'ObjectDN'                 = 'ObjectDN'
                'ObjectGUID'               = 'ObjectGUID'
                'ObjectClass'              = 'ObjectClass'
                'AttributeLDAPDisplayName' = 'AttributeLDAPDisplayName'
                #'AttributeSyntaxOID'       = 'AttributeSyntaxOID'
                'AttributeValue'           = 'AttributeValue'
                'OperationType'            = 'OperationType'
                'OpCorrelationID'          = 'OperationCorelationID'
                'AppCorrelationID'         = 'OperationApplicationCorrelationID'
                'DSName'                   = 'DSName'
                'DSType'                   = 'DSType'
                'Task'                     = 'Task'
                'Version'                  = 'Version'
                # Common Fields
                'ID'                       = 'Event ID'
                'GatheredFrom'             = 'Gathered From'
                #'GatheredLogName'          = 'Gathered LogName'
            }

            SortBy      = 'Record ID'
            Descending  = $false
            IgnoreWords = @{

            }
        }  # 5136, 5137, 5141
        'Group Policy Links'        = @{
            Enabled     = $true
            Events      = 5136, 5137, 5141
            #5136: DS Access - Directory Service Changes - A directory service object was modified.
            #5137: DS Access - Directory Service Changes - A directory service object was created.
            #5141: DS Access - Directory Service Changes - A directory service object was deleted.
            LogName     = 'Security'
            Filter      = @{
                # Filter is special, if there is just one object on the right side
                # If there are more objects filter will pick all values on the right side and display them as required
                'ObjectClass' = 'domainDNS'
                #'OperationType'            = 'Value Added'
                #'AttributeLDAPDisplayName' = 'versionNumber'
            }
            Functions   = @{
                'OperationType' = 'ConvertFrom-OperationType'
            }
            Fields      = [ordered] @{
                'RecordID'                 = 'Record ID'
                #'Computer'                 = 'Domain Controller'
                'Action'                   = 'Action'
                'Who'                      = 'Who'
                'Date'                     = 'When'
                'ObjectDN'                 = 'ObjectDN'
                'ObjectGUID'               = 'ObjectGUID'
                'ObjectClass'              = 'ObjectClass'
                'AttributeLDAPDisplayName' = 'AttributeLDAPDisplayName'
                #'AttributeSyntaxOID'       = 'AttributeSyntaxOID'
                'AttributeValue'           = 'AttributeValue'
                'OperationType'            = 'OperationType'
                'OpCorrelationID'          = 'OperationCorelationID'
                'AppCorrelationID'         = 'OperationApplicationCorrelationID'
                'DSName'                   = 'DSName'
                'DSType'                   = 'DSType'
                'Task'                     = 'Task'
                'Version'                  = 'Version'
                # Common Fields
                'ID'                       = 'Event ID'
                'GatheredFrom'             = 'Gathered From'
                #'GatheredLogName'          = 'Gathered LogName'
            }

            SortBy      = 'Record ID'
            Descending  = $false
            IgnoreWords = @{

            }
        }  # 5136, 5137, 5141
    } # 5136,5137,5141
    ADLogsClearedSecurity               = @{
        Enabled = $false
        Events  = @{
            Enabled     = $true
            Events      = 1102, 1105
            LogName     = 'Security'
            Fields      = [ordered] @{
                'Computer'        = 'Domain Controller'
                'Action'          = 'Action'
                'BackupPath'      = 'Backup Path'
                'Channel'         = 'Log Type'

                'Who'             = 'Who'
                'Date'            = 'When'

                # Common Fields
                'ID'              = 'Event ID'
                'RecordID'        = 'Record ID'
                'GatheredFrom'    = 'Gathered From'
                'GatheredLogName' = 'Gathered LogName'
                #'Test' = 'Test'
            }
            SortBy      = 'When'
            IgnoreWords = @{}
            Overwrite   = @{
                # Allows to overwrite field content on the fly, either only on IF or IF ELSE
                # IF <VALUE> -eq <VALUE> THEN <VALUE> (3 VALUES)
                # IF <VALUE> -eq <VALUE> THEN <VALUE> ELSE <VALUE> (4 VALUES)
                # If you need to use IF multiple times for same field use spaces to distinguish HashTable Key.

                'Backup Path' = 'Backup Path', '', 'N/A'
                #'Backup Path ' = 'Backup Path', 'C:\Windows\System32\Winevt\Logs\Archive-Security-2018-11-24-09-25-36-988.evtx', 'MMMM'
                'Who'         = 'Event ID', 1105, 'Automatic Backup'  # if event id 1105 set field to Automatic Backup
                #'Test' = 'Event ID', 1106, 'Test', 'Mama mia'
            }
        }
    }           # 1102,1105 (Disabled)
    ADLogsClearedOther                  = @{
        Enabled = $false
        Events  = @{
            Enabled     = $true
            Events      = 104
            LogName     = 'System'
            IgnoreWords = @{}
            Fields      = [ordered] @{
                'Computer'     = 'Domain Controller'
                'Action'       = 'Action'
                'BackupPath'   = 'Backup Path'
                'Channel'      = 'Log Type'

                'Who'          = 'Who'
                'Date'         = 'When'

                # Common Fields
                'ID'           = 'Event ID'
                'RecordID'     = 'Record ID'
                'GatheredFrom' = 'Gathered From'
            }
            SortBy      = 'When'
            Overwrite   = @{
                # Allows to overwrite field content on the fly, either only on IF or IF ELSE
                # IF <VALUE> -eq <VALUE> THEN <VALUE> (3 VALUES)
                # IF <VALUE> -eq <VALUE> THEN <VALUE> ELSE <VALUE> (4 VALUES)
                # If you need to use IF multiple times for same field use spaces to distinguish HashTable Key.
                'Backup Path' = 'Backup Path', '', 'N/A'
            }
        }
    }           # 104 (Disabled)
    ADEventsReboots                     = @{
        Enabled = $false
        Events  = @{
            Enabled     = $true
            Events      = 1001, 1018, 1, 12, 13, 42, 41, 109, 1, 6005, 6006, 6008, 6013
            LogName     = 'System'
            IgnoreWords = @{

            }
        }
    }           # 1,1,12,13,42,41,109,1001,1018,6005,6006,6008,6013 (Disabled)
}

<#
|     |    |    |    |    |    |    |    |    |    |    |    |4720|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4738|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |5136|5137|    |5141|    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |5136|5137|    |5141|    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |5136|5137|5139|5141|    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |4722|4723|4724|4725|4726|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4767|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4740|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |4624 (Disabled)    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4767|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4741|4742|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4743|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4768 (Disabled)    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4728|4729|    |    |4732|4733|    |    |    |    |    |    |    |    |    |4746|4747|    |    |    |4751|4752|    |    |4756|4757|    |    |    |4761|4762|    |    |    |    |    |4785|4786|4787|4788|    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4798|4799|    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4735|4737|    |    |    |    |    |4745|    |    |    |    |4750|    |    |    |    |    |    |    |    |4760|    |    |    |4764|    |    |4784|    |    |    |    |4791|    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |4727|    |    |4730|4731|    |    |4734|    |    |    |    |    |    |4744|    |    |    |4748|4749|    |    |    |4753|4754|    |    |4758|4759|    |    |    |4763|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |5136|5137|    |5141|    |    |    |    |
|     |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |5136|5137|    |5141|    |    |    |    |
|     |    |    |    |    |    |    |    |1102|1105 (Disabled)    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|     |    |    |    |    | 104 (Disabled)    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
| 1,1 | 12 | 13 | 42 | 41 |    | 109|1001|    |    |1018|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |6005|6006|6008|6013 (Disabled)
#>

<# Event Definitions
ADUserChanges:                       4720, 4738
    4720: A user account was created.
    4738: A user account was changed.
ADUserChangesDetailed:               5136, 5137, 5141
    5136: A directory service object was modified.
    5137: A directory service object was created.
    5141: A directory service object was deleted.
ADComputerChangesDetailed:           5136, 5137, 5141
    5136: A directory service object was modified.
    5137: A directory service object was created.
    5141: A directory service object was deleted.
ADOrganizationalUnitChangesDetailed: 5136, 5137, 5139, 5141
    5136: A directory service object was modified.
    5137: A directory service object was created.
    5139: A directory service object was moved.
    5141: A directory service object was deleted.
ADUserStatus:                        4722, 4723, 4724, 4725, 4726, 4767
    4722: A user account was enabled.
    4723: An attempt was made to change an account's password.
    4724: An attempt was made to reset an account's password.
    4725: A user account was disabled.
    4726: A user account was deleted.
    4767: A user account was unlocked.
ADUserLockouts:                      4740
    4740: A user account was locked out.
ADUserLogon: (Disabled) #4624: Logon/Logoff - Logon - An account was successfully logged on.
ADUserUnlocked:                      4767
    4767: A user account was unlocked.
ADComputerCreatedChanged:            4741, 4742
    4741: Kerberos pre-authentication failed.
    4742: A Kerberos authentication ticket request failed.
ADComputerDeleted:                   4743
    4743: A Kerberos service ticket request failed.
ADUserLogonKerberos: (Disabled)      4768
    4768: A Kerberos authentication ticket (TGT) was requested.
ADGroupMembershipChanges:            4728, 4729, 4732, 4733, 4746, 4747, 4751, 4752, 4756, 4757, 4761, 4762, 4785, 4786, 4787, 4788
    4728: A member was added to a security-enabled global group.
    4729: A member was removed from a security-enabled global group.
    4732: A member was added to a security-enabled local group.
    4733: A member was removed from a security-enabled local group.
    4746: A member was added to a security-disabled local group.
    4747: A member was removed from a security-disabled local group.
    4751: A member was added to a security-disabled global group.
    4752: A member was removed from a security-disabled global group.
    4756: A member was added to a security-enabled universal group.
    4757: A member was removed from a security-enabled universal group.
    4761: A member was added to a security-disabled universal group.
    4762: A member was removed from a security-disabled universal group.
    4785: A member was added to a basic application group.
    4786: A member was removed from a basic application group.
    4787: A non-member was added to a basic application group.
    4788: A non-member was removed from a basic application group.
ADGroupEnumeration:                  4798, 4799
    4798: A user's local group membership was enumerated. 
    4799: A security-enabled local group membership was enumerated.
ADGroupChanges:                      4735, 4737, 4745, 4750, 4760, 4764, 4784, 4791
    4735: A security-enabled local group was changed.
    4737: A security-enabled global group was changed.
    4745: A security-disabled local group was changed.
    4750: A security-disabled global group was changed.
    4760: A security-disabled universal group was changed.
    4764: A group’s type was changed.
    4784: A basic application group was changed.
    4791: A basic application group was changed.
ADGroupCreateDelete:                 4727, 4730, 4731, 4734, 4744, 4748, 4749, 4753, 4754, 4758, 4759, 4763
    4727: A security-enabled global group was created.
    4730: A security-enabled global group was deleted.
    4731: A security-enabled local group was created.
    4734: A security-enabled local group was deleted.
    4744: A security-disabled local group was created.
    4748: A security-disabled local group was deleted.
    4749: A security-disabled global group was created.
    4753: A security-disabled global group was deleted.
    4754: A security-enabled universal group was created.
    4758: A security-enabled universal group was deleted.
    4759: A security-disabled universal group was created.
    4763: 
ADGroupChangesDetailed               5136, 5137, 5141
    5136: A directory service object was modified.
    5137: A directory service object was created.
    5141: A directory service object was deleted.
ADGroupPolicyChanges                 5136, 5137, 5141
    5136: A directory service object was modified.
    5137: A directory service object was created.
    5141: A directory service object was deleted.
ADLogsClearedSecurity:               1102, 1105
ADLogsClearedOther:                  104
ADEventsReboots - Disabled - 1001, 1018, 1, 12, 13, 42, 41, 109, 1, 6005, 6006, 6008, 6013
#>
Start-WinReporting -Options $Options -Times $Times -Definitions $DefinitionsAD -Target $Target -Verbose
