package test;

import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;

import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;

import model.Asiakas;
import model.dao.Dao;

@TestMethodOrder(OrderAnnotation.class)
class JUnit_testaa_asiakkaat {

	@Test
	@Order(1)
	public void testPoistaKaikkiAsiakkaat() {
		//poistetaan kaikki asiakkaat
		Dao dao = new Dao();
		dao.poistaKaikkiAsiakkaat("nimda");
		ArrayList<Asiakas> asiakkaat = dao.listaaKaikki();
		assertEquals(0, asiakkaat.size());
	}
	
	@Test
	@Order(2)
	public void testiLisaaAsiakas() {
		Dao dao = new Dao();
		Asiakas asiakas_1 = new Asiakas(13,"Mika", "Salonen", "053655662", "mika.s@joku.com");
		Asiakas asiakas_2 = new Asiakas(14, "Mirkku", "Mallikas", "63525556", "mirkku@mallikas.com");
		assertEquals(true, dao.lisaaAsiakas(asiakas_1));
		assertEquals(true, dao.lisaaAsiakas(asiakas_2));
	}
}
