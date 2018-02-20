package don.com.moviesiak.activity;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import don.com.moviesiak.Constants;
import don.com.moviesiak.R;

public class DetailActivity extends AppCompatActivity {


    TextView tvTitle, tvYear, tvRating, tvOverview;

    String moviePoster,movieTitle,movieYear,movieOverview;
    ImageView imageView;
    Double movieRating;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        imageView = (ImageView)findViewById(R.id.iv_poster);
        tvTitle = (TextView) findViewById(R.id.tv_title);
        tvYear = (TextView) findViewById(R.id.tv_year);
        tvRating = (TextView) findViewById(R.id.tv_rating);
        tvOverview = (TextView) findViewById(R.id.tv_overview);

        Bundle extras = getIntent().getExtras();

        if (extras != null) {
            moviePoster = extras.getString("MOVIE_POSTER");
            Log.d("POSTER",moviePoster);
            movieTitle = extras.getString("MOVIE_TITLE");
            movieYear = extras.getString("MOVIE_YEAR");
            movieRating = extras.getDouble("MOVIE_RATING");
            movieOverview = extras.getString("MOVIE_OVERVIEW");

        }

        //set imageurl + posterPath ke imageView
        Picasso.with(getApplicationContext())
                .load(Constants.BASE_IMAGE_URL+moviePoster)
                .fit()
                .into(imageView);

        //set string  text ke masing - masing textView
        tvTitle.setText(movieTitle);
        tvYear.setText(movieYear);
        tvRating.setText(String.valueOf(movieRating));
        tvOverview.setText(movieOverview);
    }
}
