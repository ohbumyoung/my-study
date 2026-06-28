package com.kh.ex1.run;
import com.kh.ex1.model.vo.Movie;
public class Run {

	public static void main(String[] args) {
		
		Movie m1 = new Movie("범죄도시", 132, "19");
		Movie m2 = new Movie("뽀로로", 109, "5");

        System.out.println("m1");
        m1.showInfo();
        m1.movie1();
       
        System.out.println();

        System.out.println("m2");
        m2.showInfo();
        m2.movie2();

	}

}
