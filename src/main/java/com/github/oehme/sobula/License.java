package com.github.oehme.sobula;

import java.util.regex.Pattern;

public enum License {
	EPL_V1_0(
		"EPL-1.0", 
		"Eclipse Public License, Version 1.0", 
		"https://www.eclipse.org/legal/epl-v10.html",
		"Eclipse Public License\\s+-\\s+v 1.0"
	), 
	MIT(
		"MIT", 
		"The MIT License", 
		"http://opensource.org/licenses/MIT",
		Pattern.quote(
			"Permission is hereby granted, free of charge, to any person obtaining a copy\n" +
	        "of this software and associated documentation files (the \"Software\"), to deal\n" +
	        "in the Software without restriction, including without limitation the rights\n" +
	        "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n" +
	        "copies of the Software, and to permit persons to whom the Software is\n" +
	        "furnished to do so, subject to the following conditions:")
	), 
	APACHE_V2_0(
		"Apache-2.0", 
		"Apache License, Version 2.0", 
		"http://www.apache.org/licenses/LICENSE-2.0",
		"Apache License\\s+Version 2.0, January 2004"
	),
	GPL_V2_0(
			"GPL-2.0", 
			"GNU General Public License Version 2, June 1991", 
			"http://www.gnu.org/licenses/gpl-2.0",
			"GNU GENERAL PUBLIC LICENSE\\s+Version 2, June 1991"
	),
	LGPL_V2_1(
			"LGPL-2.1", 
			"GNU Lesser General Public License Version 2.1, February 1999", 
			"http://www.gnu.org/licenses/lgpl-2.1",
			"GNU LESSER GENERAL PUBLIC LICENSE\\s+Version 2.1, February 1999"
	),
	GPL_V3_0(
			"GPL-3.0", 
			"GNU General Public License Version 3, 29 June 2007", 
			"http://www.gnu.org/licenses/gpl-3.0",
			"GNU GENERAL PUBLIC LICENSE\\s+Version 3, 29 June 2007"
	),
	LGPL_V3_0(
			"LGPL-3.0", 
			"GNU Lesser General Public License Version 3, 29 June 2007", 
			"http://www.gnu.org/licenses/lgpl-3.0",
			"GNU LESSER GENERAL PUBLIC LICENSE\\s+Version 3, 29 June 2007"
	),
	AGPL_V3_0(
			"AGPL-3.0", 
			"GNU Affero General Public License Version 3, 19 November 2007", 
			"http://www.gnu.org/licenses/agpl-3.0.html",
			"GNU AFFERO GENERAL PUBLIC LICENSE\\s+Version 3, 19 November 2007"
	);
	
	private String id;
	private String longName;
	private String url;
	private String[] recognitionPatterns;
	
	public String getId() {
		return id;
	}
	
	public String getLongName() {
		return longName;
	}
	
	public String getUrl() {
		return url;
	}
	
	public boolean matches(String licenseText) {
		if (licenseText.contains(longName))
			return true;
		for (String recognitionPattern : recognitionPatterns) {
			Pattern pattern = Pattern.compile(recognitionPattern);
			if (pattern.matcher(licenseText).find())
				return true;
		}
		return false;
		
	}

	private License(String id, String longName, String url, String... recognitionPatterns) {
		this.id = id;
		this.longName = longName;
		this.url = url;
		this.recognitionPatterns = recognitionPatterns;
	}
}
