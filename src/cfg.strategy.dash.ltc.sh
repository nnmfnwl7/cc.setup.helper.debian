cc_setup_helper_version="20210827"

cc_dxbot_naming_suffix_default="default"
cc_ticker_maker="DASH"
cc_ticker_taker="LTC"

cc_address_funds_only="True"

cc_address_maker_default="{cc_address_maker}"
cc_address_taker_default="{cc_address_taker}"

cc_sell_size_asset="BLOCK"
cc_sell_size_asset_opposite="BLOCK"

# automatic maker price gathering
cc_maker_price=0
cc_price_source_argval="--usecg"

# flush all canceled orders every 60 seconds
cc_flush_canceled_orders=60

# first placed orders
cc_sell_start_spread="1.99"
cc_sell_start_spread_opposite="1.99"
cc_sell_start="15"
cc_sell_start_min="10"
# last palced order
cc_sell_end_spread="1.03"
cc_sell_end="15"
cc_sell_end_min="10"

cc_max_open_orders="5"
cc_make_next_on_hit="False"
cc_partial_orders="True"

cc_reopen_finished_num=1
cc_reopen_finished_delay=600

cc_reset_on_price_change_positive=0.01
cc_reset_on_price_change_negative=0.05

cc_reset_after_delay=0
cc_reset_after_order_finish_number=3
cc_reset_after_order_finish_delay=0

cc_boundary_asset_argval=" "
cc_boundary_asset_track_argval=" "
cc_boundary_reversed_pricing_argval=" "
cc_boundary_start_price_argval=" "
cc_boundary_max_argval=" "
cc_boundary_min_argval=" "

#~ cc_boundary_asset_argval="--boundary_asset USDT"
#~ cc_boundary_start_price_argval="--boundary_start_price 1"
cc_boundary_max_argval="--boundary_max_relative 1.5"
cc_boundary_min_argval="--boundary_min_relative 0.99"

#~ cc_boundary_asset_argval="--boundary_asset USDT"
#~ cc_boundary_asset_track_argval="--boundary_asset_track True"
#~ cc_boundary_reversed_pricing_argval="--boundary_reversed_pricing False"
#~ cc_boundary_reversed_pricing_argval_opposite="--boundary_reversed_pricing True"
#~ cc_boundary_max_argval="--boundary_max_static 1.5"
#~ cc_boundary_min_argval="--boundary_min_static 0.95"

cc_takerbot="0"

cc_slide_dyn_asset="BLOCK"
cc_slide_dyn_asset_track="True"
cc_slide_dyn_zero_type="relative"
cc_slide_dyn_zero="-2"
cc_slide_dyn_type="static"

cc_slide_dyn_sell_ignore=10
cc_slide_dyn_sell_threshold=10
cc_slide_dyn_sell_step=0.01
cc_slide_dyn_sell_step_multiplier=1.5
cc_slide_dyn_sell_max=1

cc_slide_dyn_buy_ignore=10
cc_slide_dyn_buy_threshold=10
cc_slide_dyn_buy_step=0.005
cc_slide_dyn_buy_step_multiplier=1.5
cc_slide_dyn_buy_max=1

cc_balance_save_number=0
cc_balance_save_percent=0

cc_im_really_sure_what_im_doing_argval=" "
#~ cc_im_really_sure_what_im_doing_argval="--imreallysurewhatimdoing 0"

# include default help for variables that will be loaded when not already set
source "$(dirname "${BASH_SOURCE[0]}")/cfg.strategy.default_help.sh" || exit 1
