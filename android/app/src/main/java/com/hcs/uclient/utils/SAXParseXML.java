package com.hcs.uclient.utils;

import com.jizhi.jlongg.main.bean.WorkType;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import java.util.ArrayList;
import java.util.List;

public class SAXParseXML extends DefaultHandler {
	private List<WorkType> workTypes;
	private WorkType workType;
	private StringBuffer buffer = new StringBuffer();

	public List<WorkType> getProducts() {
		return workTypes;
	}

	@Override
	public void startDocument() throws SAXException {
		workTypes = new ArrayList<WorkType>();
		super.startDocument();
	}

	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {
		if (localName.equals("worktype")) {
			workType = new WorkType();
		}
		super.startElement(uri, localName, qName, attributes);
	}

	@Override
	public void endElement(String uri, String localName, String qName)
			throws SAXException {
		if (localName.equals("worktype")) {
			workTypes.add(workType);
		} else if (localName.equals("id")) {
			workType.setWorktype(buffer.toString().trim());
			buffer.setLength(0);
		} else if (localName.equals("name")) {
			workType.setWorkName(buffer.toString().trim());
			buffer.setLength(0);
		} 
		super.endElement(uri, localName, qName);
	}

	@Override
	public void characters(char[] ch, int start, int length)
			throws SAXException {
		buffer.append(ch, start, length);
		super.characters(ch, start, length);
	}

}
