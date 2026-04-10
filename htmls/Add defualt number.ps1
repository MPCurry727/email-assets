$OUs = @(
    @{
        SearchBase = "OU=Acura Users,OU=Acura,DC=curryauto,DC=com"
        Phone = "(914) 472-6800"
    },
    @{
        SearchBase = "OU=Chevy Users,OU=Chevy,DC=curryauto,DC=com"
        Phone = "(914) 723-9200"
    },
    @{
        SearchBase = "OU=Honda MA Users,OU=Honda MA,DC=curryauto,DC=com"
        Phone = "(413) 593-6721"
    },
    @{
        SearchBase = "OU=Honda NY Users,OU=Honda NY,DC=curryauto,DC=com"
        Phone = "(914) 739-7600"
    },
    @{
        SearchBase = "OU=MBOFD Users,OU=MBOFD,DC=curryauto,DC=com"
        Phone = "(203) 778-6333"
    },
    @{
        SearchBase = "OU=MBOFWF Users,OU=MBOFWF,DC=curryauto,DC=com"
        Phone = "(845) -298-0600"
    },
    @{
        SearchBase = "OU=Nissan MA Users,OU=Nissan MA,DC=curryauto,DC=com"
        Phone = "(413) 474-6800"
    },
    @{
        SearchBase = "OU=ToyotaUsers,OU=Toyota,DC=curryauto,DC=com"
        Phone = "(914) 930-3800"
    },
    @{
        SearchBase = "OU=Subaru Kingston Users,OU=Subaru Kingston,DC=curryauto,DC=com"
        Phone = "(845) 339-3333"
    },
	@{
        SearchBase = "OU=HyuSub Users,OU=HyuSub,DC=curryauto,DC=com"
        Phone = "(914) 930-3700"
    },
    @{
        SearchBase = "OU=Grenadier Users,OU=Grenadier,DC=curryauto,DC=com"
        Phone = "(203) 448-1100"
    }
)

foreach ($OU in $OUs) {
    Get-ADUser -SearchBase $OU.SearchBase -Filter * -Properties telephoneNumber |
    Where-Object { -not $_.telephoneNumber } |
    Set-ADUser -Replace @{telephoneNumber=$OU.Phone}
}