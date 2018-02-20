package don.com.moviesiak.activity;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.widget.Toast;

import java.util.Calendar;
import java.util.List;

import don.com.moviesiak.Constants;
import don.com.moviesiak.R;
import don.com.moviesiak.adapter.MainAdapter;
import don.com.moviesiak.model.MainModel;
import don.com.moviesiak.model.ResultsItem;
import don.com.moviesiak.services.ApiClient;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class MainActivity extends AppCompatActivity {


    private String MY_TAG = MainActivity.class.getSimpleName();

    RecyclerView recyclerView;

    MainAdapter adapter;

    ApiClient apiClient;

    List<ResultsItem> resultsItems;

    String myApiKey;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        recyclerView = (RecyclerView) findViewById(R.id.rv_main);

        myApiKey = getString(R.string.api_key);
        Log.d(MY_TAG, myApiKey);


        getMyMovies();
    }


    private void getMyMovies() {
        apiClient = new ApiClient();
        Call<MainModel> call = apiClient.getApiInterface().getNowPlayingMovies(myApiKey, 1);
        call.enqueue(new Callback<MainModel>() {
            @Override
            public void onResponse(Call<MainModel> call, Response<MainModel> response) {
                if (response.isSuccessful()) {
                    Log.d(MY_TAG, "SUKSES");

                    MainModel mainModel = response.body();
                    resultsItems = mainModel.getResults();

                    //ini gunanya untuk membuat smooth scroll
                    recyclerView.setHasFixedSize(true);

                    //kita set layout manager untuk recyclerview
                    recyclerView.setLayoutManager(new GridLayoutManager(getApplicationContext(),2));

                    //ngambil data adapter
                    adapter = new MainAdapter(resultsItems, getApplicationContext());

                    //set data dari adapter ke recyclerview
                    recyclerView.setAdapter(adapter);

                }
            }

            @Override
            public void onFailure(Call<MainModel> call, Throwable t) {
                Log.d(MY_TAG, t.getMessage());
                Log.d(MY_TAG, "GAGAL-2");
            }
        });


    }


}
