package don.com.moviesiak.services;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import don.com.moviesiak.Constants;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by gideon on 11/02/18.
 */

public class ApiClient {

    private ApiInterface apiInterface;


    public ApiInterface getApiInterface() {

        //-------------------------------------
        //ADD LOGGING INTERCEPTOR
        HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
        logging.setLevel(HttpLoggingInterceptor.Level.BODY);
        OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
        httpClient.addInterceptor(logging);  // <-- this is the important line!
        //--------------------------------------


        if (apiInterface == null) {


            Gson gson = new GsonBuilder()
                    .serializeNulls()
                    .create();

            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(Constants.BASE_URL)
                    .client(httpClient.build())
                    .addConverterFactory(GsonConverterFactory.create(gson))
                    .build();

            apiInterface = retrofit.create(ApiInterface.class);

        }

        return apiInterface;
    }

}
