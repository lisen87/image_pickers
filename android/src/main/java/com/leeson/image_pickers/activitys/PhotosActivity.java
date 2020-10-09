package com.leeson.image_pickers.activitys;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import com.bumptech.glide.Glide;
import com.bumptech.glide.Priority;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.leeson.image_pickers.R;
import com.leeson.image_pickers.utils.CommonUtils;

import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;
import uk.co.senab.photoview.PhotoViewAttacher;


/**
 * Created by Administrator on 2017/5/23.
 * lisen
 * <p>
 * 查看多张图片的页面
 * <p/>
 */

public class PhotosActivity extends BaseActivity {


    public static final String IMAGES = "IMAGES";
    public static final String CURRENT_POSITION = "CURRENT_POSITION";
    ViewPager viewPager;
    LinearLayout layout_tip;

    private List<String> images;
    private Number currentPosition;


    private LayoutInflater inflater;

    private class Adapter extends PagerAdapter {

        @Override
        public int getCount() {
            return images.size();
        }

        @Override
        public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
            return view == object;
        }

        @NonNull
        @Override
        public Object instantiateItem(@NonNull final ViewGroup container, final int position) {
            View view = inflater.inflate(R.layout.item_activity_photos, container, false);
            final ProgressBar progressBar = (ProgressBar) view.findViewById(R.id.progressBar);
            final ImageView photoView = (ImageView) view.findViewById(R.id.photoView);
            final PhotoViewAttacher attacher = new PhotoViewAttacher(photoView);
            attacher.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View view) {
                        /*if (TextUtils.isEmpty(momontId)){
                            return false;
                        }else{
                        }*/
                    return true;
                }
            });
            attacher.setOnViewTapListener(new PhotoViewAttacher.OnViewTapListener() {
                @Override
                public void onViewTap(View view, float x, float y) {
                    finish();
                }
            });
            progressBar.setVisibility(View.VISIBLE);
            String url = images.get(position);
            if (!TextUtils.isEmpty(url) && url.endsWith(".gif")) {

                Glide.with(PhotosActivity.this)
                        .asGif()
                        .diskCacheStrategy(DiskCacheStrategy.NONE)
                        .priority(Priority.HIGH)
                        .load(url)
                        .listener(new RequestListener<GifDrawable>() {
                            @Override
                            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<GifDrawable> target, boolean isFirstResource) {
                                return false;
                            }

                            @Override
                            public boolean onResourceReady(GifDrawable resource, Object model, Target<GifDrawable> target, DataSource dataSource, boolean isFirstResource) {
                                int resWidth = resource.getIntrinsicWidth();
                                int reHeight = resource.getIntrinsicHeight();
                                float scaleWH = (float) resWidth / (float) reHeight;
                                int photoViewHeight = (int) (CommonUtils.getScreenWidth(PhotosActivity.this) /scaleWH);
                                ViewGroup.LayoutParams layoutParams = photoView.getLayoutParams();
                                layoutParams.width =  CommonUtils.getScreenWidth(PhotosActivity.this);
                                layoutParams.height = photoViewHeight;
                                photoView.setLayoutParams(layoutParams);

                                attacher.update();
                                progressBar.setVisibility(View.GONE);
                                photoView.setImageDrawable(resource);
                                return false;
                            }
                        }).into(photoView);

            } else {

                Glide.with(PhotosActivity.this).asDrawable().load(url).listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        photoView.setImageDrawable(resource);
                        attacher.update();
                        progressBar.setVisibility(View.GONE);
                        return false;
                    }
                }).into(photoView);
            }
            container.addView(view);
            return view;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            View view = (View) object;
            container.removeView(view);
        }
    }

    public int dp2px(float dpValue) {
        final float scale = getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_photos);
        viewPager = findViewById(R.id.viewPager);
        layout_tip = findViewById(R.id.layout_tip);
        inflater = LayoutInflater.from(this);
        images = getIntent().getStringArrayListExtra(IMAGES);
        currentPosition = getIntent().getIntExtra(CURRENT_POSITION, 0);

        if (images != null && images.size() > 0) {

            if (images.size() < 10 && images.size() > 1) {

                for (int i = 0; i < images.size(); i++) {
                    View view = new View(this);
                    if (0 == i) {
                        view.setBackground(ContextCompat.getDrawable(this, R.drawable.circle_white));
                    } else {
                        view.setBackground(ContextCompat.getDrawable(this, R.drawable.circle_gray));
                    }
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                    params.width = params.height = dp2px(6);
                    params.leftMargin = params.rightMargin = dp2px(5);
                    view.setLayoutParams(params);
                    layout_tip.addView(view);
                }
            }
        }

        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                if (images.size() < 10) {
                    reset(position);
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });

        viewPager.setAdapter(new Adapter());
        viewPager.setCurrentItem(currentPosition.intValue());
    }

    private void reset(int pos) {
        for (int i = 0; i < layout_tip.getChildCount(); i++) {
            View view = layout_tip.getChildAt(i);
            view.setBackground(ContextCompat.getDrawable(this, R.drawable.circle_gray));
        }
        layout_tip.getChildAt(pos).setBackground(ContextCompat.getDrawable(this, R.drawable.circle_white));
    }
}
