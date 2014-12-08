package com.github.oehme.sobula;

public enum License {
	EPL_V1_0(
		"EPL-1.0", 
		"Eclipse Public License, Version 1.0", 
		"http://opensource.org/licenses/EPL-1.0",
		"Eclipse Public License - v 1.0"
	), 
	MIT(
		"MIT", 
		"The MIT License", 
		"http://opensource.org/licenses/MIT"
	), 
	APACHE_V2_0(
		"Apache-2.0", 
		"Apache License, Version 2.0", 
		"http://opensource.org/licenses/Apache-2.0"
	);
	
	private String id;
	private String longName;
	private String url;
	private String[] aliaes;
	
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
		for (String alias : aliaes) {
			if (licenseText.contains(alias))
				return true;
		}
		return false;
		
	}

	private License(String id, String longName, String url, String... aliases) {
		this.id = id;
		this.longName = longName;
		this.url = url;
		this.aliaes = aliases;
	}
}
