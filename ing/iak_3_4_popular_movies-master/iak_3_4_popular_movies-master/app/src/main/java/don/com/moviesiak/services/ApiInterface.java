package don.com.moviesiak.services;

import don.com.moviesiak.model.MainModel;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

/**
 * Created by gideon on 11/02/18.
 */

public interface ApiInterface {


    /**
     * API CALL UNTUK MENGAMBIL NOW PLAYING MOVIE..
     * DENGAN END POINT "MOVIE/NOW_PLAYING"
     * @param apiKey (Api Key kita)
     * @param pageNumber (Page Number, example -> 1);
     * @return
     *
     */
    @GET("movie/now_playing")
    Call<MainModel> getNowPlayingMovies(
            @Query("api_key") String  apiKey,
            @Query("page") int pageNumber);


}
