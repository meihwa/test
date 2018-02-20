package don.com.moviesiak.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;


import com.squareup.picasso.Picasso;

import java.util.List;

import don.com.moviesiak.Constants;
import don.com.moviesiak.R;
import don.com.moviesiak.activity.DetailActivity;
import don.com.moviesiak.model.ResultsItem;


/**
 * Created by gideon on 11/02/18.
 */

public class MainAdapter extends RecyclerView.Adapter<MainAdapter.MyViewHolder> {

    List<ResultsItem> data;
    Context context;

    public MainAdapter(List<ResultsItem> data, Context context) {
        this.data = data;
        this.context = context;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        //ADD VIEW TO VIEW HOLDER WHICH IS LIST ITEM LAYOUT
        //
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.list_item_layout, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {


   /*    -----------cuma bikin gambar doang ------
   ///set text ke holder setelah data di dapatkan
        holder.tvName.setText(data.get(position).getTitle());
        holder.tvOverview.setText(data.get(position).getOverview());*/
   /*-----------------------------------------------------------------*/



        String pathPoster = data.get(position).getPosterPath();
        //image picasso
        Picasso.with(context)
                .load(Constants.BASE_IMAGE_URL + pathPoster)
                .fit()
                .into(holder.imageView);
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    class MyViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        private ImageView imageView;

        public MyViewHolder(View itemView) {
            super(itemView);
            imageView = itemView.findViewById(R.id.iv_poster);
          //set click listener for  viewholder
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {

            Log.d("TAG","onClick "+ getAdapterPosition());

            Intent intent = new Intent(context,DetailActivity.class);
            intent.putExtra("MOVIE_POSTER",data.get(getAdapterPosition()).getPosterPath());
            intent.putExtra("MOVIE_TITLE",data.get(getAdapterPosition()).getTitle());
            intent.putExtra("MOVIE_YEAR",data.get(getAdapterPosition()).getReleaseDate());
            intent.putExtra("MOVIE_RATING",data.get(getAdapterPosition()).getVoteAverage());
            intent.putExtra("MOVIE_OVERVIEW",data.get(getAdapterPosition()).getOverview());
            context.startActivity(intent);

        }
    }
}
