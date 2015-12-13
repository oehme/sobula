/*******************************************************************************
 * Copyright (c) 2015 Denis Kuniss (http://www.grammarcraft.de).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package com.github.oehme.sobula;

import org.junit.Test

import static org.junit.Assert.*

/**
 * @author kuniss@grammarcraft.de
 */
public class LicenseTest {

    def assertOnlyMatchedBy(License license, String licenseText) {
        assertTrue(license.matches(licenseText))
        License.values.filter[it != license].forEach[assertFalse(matches(licenseText))]
    }

	@Test
	def void match_Eclipse10_license() {
	    val licenseText = '''
            Eclipse Public License - v 1.0
            
            THE ACCOMPANYING PROGRAM IS PROVIDED UNDER THE TERMS OF THIS ECLIPSE PUBLIC LICENSE ("AGREEMENT"). ANY USE, REPRODUCTION OR DISTRIBUTION OF THE PROGRAM CONSTITUTES RECIPIENT'S ACCEPTANCE OF THIS AGREEMENT.
            
            1. DEFINITIONS
            
            "Contribution" means:
            ...
        '''
        assertOnlyMatchedBy(License.EPL_V1_0, licenseText)
	}

    @Test
    def void match_Apache20_license() {
        val licenseText = '''
                                          Apache License
                                    Version 2.0, January 2004
                                 http://www.apache.org/licenses/
                    
            TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
                    
            1. Definitions.
            ...
        '''
        assertOnlyMatchedBy(License.APACHE_V2_0, licenseText)
    }

    @Test
    def void match_MIT_license() {
        val licenseText = '''
            Copyright (c) <year> <copyright holders>
            
            
            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:
            
            
            The above copyright notice and this permission notice shall be included in
            all copies or substantial portions of the Software.
            
            
            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
            THE SOFTWARE.
        '''
        assertOnlyMatchedBy(License.MIT, licenseText)
    }

    @Test
    def void match_LGPL30_license() {
        val licenseText = '''
                               GNU LESSER GENERAL PUBLIC LICENSE
                                   Version 3, 29 June 2007
            
             Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
             Everyone is permitted to copy and distribute verbatim copies
             of this license document, but changing it is not allowed.
            
            
              This version of the GNU Lesser General Public License incorporates
            the terms and conditions of version 3 of the GNU General Public
            License, supplemented by the additional permissions listed below.
            
              0. Additional Definitions.
            ...
        '''
        assertOnlyMatchedBy(License.LGPL_V3_0, licenseText)
    }

    @Test
    def void match_GPL30_license() {
        val licenseText = '''
                                GNU GENERAL PUBLIC LICENSE
                                   Version 3, 29 June 2007
            
             Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
             Everyone is permitted to copy and distribute verbatim copies
             of this license document, but changing it is not allowed.
            
                                        Preamble
            ...
        '''
        assertOnlyMatchedBy(License.GPL_V3_0, licenseText)
    }


    @Test
    def void match_LGPL21_license() {
        val licenseText = '''
                              GNU LESSER GENERAL PUBLIC LICENSE
                                   Version 2.1, February 1999
            
             Copyright (C) 1991, 1999 Free Software Foundation, Inc.
             51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
             Everyone is permitted to copy and distribute verbatim copies
             of this license document, but changing it is not allowed.
            
            [This is the first released version of the Lesser GPL.  It also counts
             as the successor of the GNU Library Public License, version 2, hence
             the version number 2.1.]
            
                                        Preamble
            ...
        '''
        assertOnlyMatchedBy(License.LGPL_V2_1, licenseText)
    }

    @Test
    def void match_GPL20_license() {
        val licenseText = '''
                                GNU GENERAL PUBLIC LICENSE
                                   Version 2, June 1991
            
             Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
             51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
             Everyone is permitted to copy and distribute verbatim copies
             of this license document, but changing it is not allowed.
            
                                        Preamble
            ...
        '''
        assertOnlyMatchedBy(License.GPL_V2_0, licenseText)
    }

    @Test
    def void match_AGPL30_license() {
        val licenseText = '''
                                GNU AFFERO GENERAL PUBLIC LICENSE
                                   Version 3, 19 November 2007
            
             Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
             Everyone is permitted to copy and distribute verbatim copies
             of this license document, but changing it is not allowed.
            
                                        Preamble
            ...
        '''
        assertOnlyMatchedBy(License.AGPL_V3_0, licenseText)
    }

}
