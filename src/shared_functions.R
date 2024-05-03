library( "marray" )
library( "tidyverse" )

####################
# ggplot constants #
####################
gg_bigger_texts = theme(
  axis.title = element_text(size = 22),
  axis.text = element_text(size = 20),
  legend.text = element_text(size = 14),
  legend.title = element_text(size = 15),
  plot.title = element_text(size = 22),
  strip.text = element_text(size = 15)
)

gg_no_legend = theme(legend.position = 'none')

gg_no_grid = theme(panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank())

gg_no_x_grid = theme(panel.grid.major.x = element_blank())

gg_no_y_grid = theme(panel.grid.major.y = element_blank())

gg_center_title = theme(plot.title = element_text(hjust = 0.5))

############
# palettes #
############
my_palette = function(kVal,
                      low = "#998ec3",
                      high = "#f1a340",
                      mid = "#f7f7f7")
{
  return(maPalette(
    low = low,
    high = high,
    mid = mid,
    k = kVal
  ))
}

colorBlindPalette <- c( "#999999",
                        "#E69F00",
                        "#56B4E9",
                        "#009E73",
                        "#F0E442",
                        "#0072B2",
                        "#D55E00",
                        "#CC79A7"
                        )

#################
# volcano plots #
#################
make_ggplot_volcano <- function( deg_dataframe,
                                 case_name,
                                 control_name,
                                 axis_steps = 2,
                                 fold_change_cutoff = 1.5,
                                 qvalue_cutoff = 0.05,
                                 max_label = 30,
                                 title_string = NULL )
{
  ##############################
  # set significance threshold #
  ##############################
  deg_dataframe <- deg_dataframe %>%
    mutate( Significant = case_when(
      qval < qvalue_cutoff & abs( FoldChange ) >= fold_change_cutoff ~ "Large",
      qval < qvalue_cutoff ~ "Modest",
      TRUE ~ "Not" ) ) %>%
    mutate( Significant = factor( Significant, levels=c( "Not", "Modest", "Large" ) ) )

  ################################
  # set values for square x axis #
  ################################
  x_volcano_value <- ( abs( deg_dataframe$log2FoldChange[ is.finite( deg_dataframe$log2FoldChange ) ] ) + 0.051 ) %>%
    max( . ) %>%
    round( ., 1 )

  if ( x_volcano_value < 1.0 ) {
    x_volcano_value = 1.0
  }

  x_num_for_limits <- round( x_volcano_value, 0 )

  x_volcano_low <- x_volcano_value * -1
  x_volcano_high <- x_volcano_value

  x_break_list <- seq( -1 * x_num_for_limits, x_num_for_limits, by = axis_steps )

  ##############
  # plot lines #
  ##############
  horizontal_line <- log10( qvalue_cutoff ) * -1
  vertical_line_1 <- log2( fold_change_cutoff )
  vertical_line_2 <- vertical_line_1 * -1

  ###################################
  # actually make the volcano plots #
  ###################################
  plot_volcano <- ggplot( deg_dataframe,
                          aes( x=log2FoldChange,
                               y=-log10( qval ),
                               colour=Significant ) ) +
    scale_colour_manual( values = c( "darkgray", "blue", "red" ) ) +
    scale_x_continuous( limits = c( x_volcano_low, x_volcano_high ),
                        breaks = x_break_list ) +
    theme_bw() +
    gg_bigger_texts +
    gg_no_legend +
    gg_no_grid +
    gg_center_title +
    geom_point( size=1.2 ) +
    geom_hline( yintercept = horizontal_line, linetype=2 ) +
    geom_vline( xintercept=c( vertical_line_1, vertical_line_2 ), linetype=2 ) +
    geom_text_repel( data=subset( deg_dataframe, Significant == "Large" )[c(1:max_label),], colour="black", aes( label=symbol ), size=3 ) +
    xlab( parse( text=paste0( "log[2]~(", case_name, "/", control_name, ")" ) ) ) +
    ylab( parse( text = paste0( "-log[10]~(Adj.~p-value)" ) ) )

  if ( !is.null( title_string ) ) {
    plot_volcano = plot_volcano +
      ggtitle( title_string ) +
      gg_center_title
  }

  return( plot_volcano )
}
