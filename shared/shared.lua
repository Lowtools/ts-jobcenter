Config = {}

Config.Locale = 'nl'

Config.Locations = {
	['Pillbox Hill'] = {
		coords = vector3(-264.373, -965.492, 31.223),
	},
}

Config.Jobs = {
	['Pillbox Hill'] = {
		{
			label = 'Pizza Bezorger', -- Job label (Required)
			description = 'Begin als pizza bezorger op de fiets.', -- Job description (Required)
			name = 'fueler', -- Job name (Required)
			grade = 0, -- Job grade (Required)
			salary = 100, -- Match the value from your Database
			icon = 'bicycle', -- Optional
		}
	}
}

Config.Locales = {
	['nl'] = {
		['success'] = 'Success',
		['error'] = 'Foutmelding', 
		['info'] = 'Informatie',
		['jobcenter'] = 'Uitzendbureau',
		['textui'] = 'Uitzendbureau',
		['invalid_job'] = 'Deze baan bestaat niet.',
		['exploit'] = 'Probeer je nou echt te exploiten?',
		['hired'] = 'Je bent aangenomen als %s.'
	},
	
	['en'] = {
		['success'] = 'Success',
		['error'] = 'Error',
		['info'] = 'Information',
		['jobcenter'] = 'Job Center',
		['textui'] = 'Job Center',
		['invalid_job'] = 'This job does not exist.',
		['exploit'] = 'Are you seriously trying to exploit?',
		['hired'] = 'You have been hired as %s.'
	}
}